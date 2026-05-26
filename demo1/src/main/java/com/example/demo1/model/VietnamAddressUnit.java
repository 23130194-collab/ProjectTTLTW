package com.example.demo1.model;

import com.google.gson.annotations.SerializedName;

import java.util.Collections;
import java.util.List;

public class VietnamAddressUnit {
    private String name;
    private int code;
    private String codename;

    @SerializedName("division_type")
    private String divisionType;

    @SerializedName("phone_code")
    private Integer phoneCode;

    private List<VietnamAddressUnit> wards;
    private List<VietnamAddressUnit> districts;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getCodename() {
        return codename;
    }

    public void setCodename(String codename) {
        this.codename = codename;
    }

    public String getDivisionType() {
        return divisionType;
    }

    public void setDivisionType(String divisionType) {
        this.divisionType = divisionType;
    }

    public Integer getPhoneCode() {
        return phoneCode;
    }

    public void setPhoneCode(Integer phoneCode) {
        this.phoneCode = phoneCode;
    }

    public List<VietnamAddressUnit> getWards() {
        return wards == null ? Collections.emptyList() : wards;
    }

    public void setWards(List<VietnamAddressUnit> wards) {
        this.wards = wards;
    }

    public List<VietnamAddressUnit> getDistricts() {
        return districts == null ? Collections.emptyList() : districts;
    }

    public void setDistricts(List<VietnamAddressUnit> districts) {
        this.districts = districts;
    }

    public String getOptionValue() {
        return code + "|" + (name == null ? "" : name);
    }
}
