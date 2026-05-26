package com.example.demo1.service;

import com.example.demo1.model.VietnamAddressUnit;
import com.google.gson.Gson;

import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class VietnamAddressService {
    private static final String API_BASE = "https://provinces.open-api.vn/api";
    private static final long CACHE_TTL_MILLIS = 60 * 60 * 1000;
    private static final Gson GSON = new Gson();
    private static final Map<Integer, CacheEntry<List<VietnamAddressUnit>>> DISTRICT_CACHE = new ConcurrentHashMap<>();
    private static final Map<Integer, CacheEntry<List<VietnamAddressUnit>>> WARD_CACHE = new ConcurrentHashMap<>();

    private static volatile CacheEntry<List<VietnamAddressUnit>> provinceCache;

    public List<VietnamAddressUnit> getProvinces() throws IOException {
        CacheEntry<List<VietnamAddressUnit>> cache = provinceCache;
        if (cache != null && !cache.isExpired()) {
            return cache.data;
        }

        String json = readUrl(API_BASE + "/");
        VietnamAddressUnit[] provinces = GSON.fromJson(json, VietnamAddressUnit[].class);
        List<VietnamAddressUnit> provinceList = provinces == null
                ? Collections.emptyList()
                : new ArrayList<>(Arrays.asList(provinces));

        provinceCache = new CacheEntry<>(provinceList);
        return provinceList;
    }

    public List<VietnamAddressUnit> getDistrictsByProvinceCode(int provinceCode) throws IOException {
        CacheEntry<List<VietnamAddressUnit>> cache = DISTRICT_CACHE.get(provinceCode);
        if (cache != null && !cache.isExpired()) {
            return cache.data;
        }

        String json = readUrl(API_BASE + "/p/" + provinceCode + "?depth=2");
        VietnamAddressUnit province = GSON.fromJson(json, VietnamAddressUnit.class);
        List<VietnamAddressUnit> districts = province == null
                ? Collections.emptyList()
                : new ArrayList<>(province.getDistricts());

        DISTRICT_CACHE.put(provinceCode, new CacheEntry<>(districts));
        return districts;
    }

    public List<VietnamAddressUnit> getWardsByDistrictCode(int districtCode) throws IOException {
        CacheEntry<List<VietnamAddressUnit>> cache = WARD_CACHE.get(districtCode);
        if (cache != null && !cache.isExpired()) {
            return cache.data;
        }

        String json = readUrl(API_BASE + "/d/" + districtCode + "?depth=2");
        VietnamAddressUnit district = GSON.fromJson(json, VietnamAddressUnit.class);
        List<VietnamAddressUnit> wards = district == null
                ? Collections.emptyList()
                : new ArrayList<>(district.getWards());

        WARD_CACHE.put(districtCode, new CacheEntry<>(wards));
        return wards;
    }

    public static Integer getCodeFromOptionValue(String value) {
        String trimmed = trim(value);
        if (trimmed.isEmpty()) {
            return null;
        }

        int separatorIndex = trimmed.indexOf('|');
        String codeText = separatorIndex >= 0 ? trimmed.substring(0, separatorIndex) : trimmed;

        try {
            return Integer.parseInt(codeText);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    public static String getNameFromOptionValue(String value) {
        String trimmed = trim(value);
        int separatorIndex = trimmed.indexOf('|');
        return separatorIndex >= 0 ? trimmed.substring(separatorIndex + 1).trim() : trimmed;
    }

    private static String readUrl(String urlText) throws IOException {
        HttpURLConnection connection = (HttpURLConnection) new URL(urlText).openConnection();
        connection.setRequestMethod("GET");
        connection.setConnectTimeout(5000);
        connection.setReadTimeout(7000);
        connection.setRequestProperty("Accept", "application/json");

        int statusCode = connection.getResponseCode();
        InputStream stream = statusCode >= 200 && statusCode < 300
                ? connection.getInputStream()
                : connection.getErrorStream();

        String responseBody = "";
        if (stream != null) {
            responseBody = new String(stream.readAllBytes(), StandardCharsets.UTF_8);
        }

        if (statusCode < 200 || statusCode >= 300) {
            throw new IOException("Province API returned " + statusCode + ": " + responseBody);
        }

        return responseBody;
    }

    private static String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private static class CacheEntry<T> {
        private final T data;
        private final long loadedAt;

        private CacheEntry(T data) {
            this.data = data;
            this.loadedAt = System.currentTimeMillis();
        }

        private boolean isExpired() {
            return System.currentTimeMillis() - loadedAt > CACHE_TTL_MILLIS;
        }
    }
}
