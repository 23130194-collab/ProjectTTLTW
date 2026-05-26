package com.example.demo1.dao;

import com.example.demo1.model.User;
import com.example.demo1.model.UserAddress;
import org.jdbi.v3.core.Handle;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class UserAddressDao {
    private static final String SELECT_COLUMNS = "SELECT id, user_id AS userId, label, full_name AS fullName, "
            + "phone, address_detail AS addressDetail, ward, district, province, full_address AS fullAddress, "
            + "is_default AS defaultAddress, created_at AS createdAt, updated_at AS updatedAt "
            + "FROM user_addresses ";
    private static volatile boolean districtColumnEnsured = false;

    private final Jdbi jdbi = DatabaseDao.get();

    public void ensureDefaultAddressForUser(User user) {
        ensureDistrictColumn();
        if (user == null || trim(user.getAddress()).isEmpty()) {
            return;
        }

        int count = countAddressesByUserId(user.getId());
        if (count > 0) {
            return;
        }

        UserAddress address = new UserAddress();
        address.setUserId(user.getId());
        address.setLabel("Mặc định");
        address.setFullName(defaultText(user.getName(), "Người nhận"));
        address.setPhone(defaultText(user.getPhone(), ""));
        address.setAddressDetail(user.getAddress().trim());
        address.setFullAddress(user.getAddress().trim());
        address.setDefaultAddress(true);
        createAddress(address);
    }

    public List<UserAddress> getAddressesByUserId(int userId) {
        ensureDistrictColumn();
        return jdbi.withHandle(handle ->
                handle.createQuery(SELECT_COLUMNS
                                + "WHERE user_id = :userId ORDER BY is_default DESC, updated_at DESC, id DESC")
                        .bind("userId", userId)
                        .mapToBean(UserAddress.class)
                        .list()
        );
    }

    public UserAddress getDefaultAddressByUserId(int userId) {
        ensureDistrictColumn();
        return jdbi.withHandle(handle -> getDefaultAddressByUserId(handle, userId));
    }

    public UserAddress getAddressById(int userId, int addressId) {
        ensureDistrictColumn();
        return jdbi.withHandle(handle -> getAddressById(handle, userId, addressId));
    }

    public UserAddress createAddress(UserAddress address) {
        ensureDistrictColumn();
        return jdbi.inTransaction(handle -> {
            boolean shouldBeDefault = address.isDefaultAddress() || countAddressesByUserId(handle, address.getUserId()) == 0;

            if (shouldBeDefault) {
                clearDefaultAddresses(handle, address.getUserId());
            }

            int addressId = handle.createUpdate(
                            "INSERT INTO user_addresses (user_id, label, full_name, phone, address_detail, ward, district, province, full_address, is_default) "
                                    + "VALUES (:userId, :label, :fullName, :phone, :addressDetail, :ward, :district, :province, :fullAddress, :defaultAddress)")
                    .bindBean(address)
                    .bind("defaultAddress", shouldBeDefault)
                    .executeAndReturnGeneratedKeys("id")
                    .mapTo(Integer.class)
                    .one();

            address.setId(addressId);
            address.setDefaultAddress(shouldBeDefault);

            if (shouldBeDefault) {
                syncUserDefaultAddress(handle, address.getUserId(), address.getFullAddress());
            }

            return address;
        });
    }

    public boolean updateAddress(UserAddress address) {
        ensureDistrictColumn();
        return jdbi.inTransaction(handle -> {
            UserAddress currentAddress = getAddressById(handle, address.getUserId(), address.getId());
            if (currentAddress == null) {
                return false;
            }

            boolean shouldBeDefault = address.isDefaultAddress() || currentAddress.isDefaultAddress();
            if (shouldBeDefault) {
                clearDefaultAddresses(handle, address.getUserId());
            }

            int updatedRows = handle.createUpdate(
                            "UPDATE user_addresses SET label = :label, full_name = :fullName, phone = :phone, "
                                    + "address_detail = :addressDetail, ward = :ward, district = :district, province = :province, "
                                    + "full_address = :fullAddress, is_default = :defaultAddress "
                                    + "WHERE id = :id AND user_id = :userId")
                    .bindBean(address)
                    .bind("defaultAddress", shouldBeDefault)
                    .execute();

            if (shouldBeDefault && updatedRows > 0) {
                syncUserDefaultAddress(handle, address.getUserId(), address.getFullAddress());
            }

            return updatedRows > 0;
        });
    }

    public boolean deleteAddress(int userId, int addressId) {
        ensureDistrictColumn();
        return jdbi.inTransaction(handle -> {
            UserAddress address = getAddressById(handle, userId, addressId);
            if (address == null) {
                return false;
            }

            int deletedRows = handle.createUpdate("DELETE FROM user_addresses WHERE id = :id AND user_id = :userId")
                    .bind("id", addressId)
                    .bind("userId", userId)
                    .execute();

            if (deletedRows == 0) {
                return false;
            }

            if (address.isDefaultAddress()) {
                UserAddress replacement = getLatestAddressByUserId(handle, userId);
                if (replacement == null) {
                    syncUserDefaultAddress(handle, userId, null);
                } else {
                    markDefaultAddress(handle, userId, replacement.getId());
                    syncUserDefaultAddress(handle, userId, replacement.getFullAddress());
                }
            }

            return true;
        });
    }

    public boolean setDefaultAddress(int userId, int addressId) {
        ensureDistrictColumn();
        return jdbi.inTransaction(handle -> {
            UserAddress address = getAddressById(handle, userId, addressId);
            if (address == null) {
                return false;
            }

            clearDefaultAddresses(handle, userId);
            markDefaultAddress(handle, userId, addressId);
            syncUserDefaultAddress(handle, userId, address.getFullAddress());
            return true;
        });
    }

    private int countAddressesByUserId(int userId) {
        return jdbi.withHandle(handle -> countAddressesByUserId(handle, userId));
    }

    private int countAddressesByUserId(Handle handle, int userId) {
        return handle.createQuery("SELECT COUNT(*) FROM user_addresses WHERE user_id = :userId")
                .bind("userId", userId)
                .mapTo(Integer.class)
                .one();
    }

    private UserAddress getDefaultAddressByUserId(Handle handle, int userId) {
        return handle.createQuery(SELECT_COLUMNS + "WHERE user_id = :userId AND is_default = 1 LIMIT 1")
                .bind("userId", userId)
                .mapToBean(UserAddress.class)
                .findOne()
                .orElse(null);
    }

    private UserAddress getAddressById(Handle handle, int userId, int addressId) {
        return handle.createQuery(SELECT_COLUMNS + "WHERE user_id = :userId AND id = :id")
                .bind("userId", userId)
                .bind("id", addressId)
                .mapToBean(UserAddress.class)
                .findOne()
                .orElse(null);
    }

    private UserAddress getLatestAddressByUserId(Handle handle, int userId) {
        return handle.createQuery(SELECT_COLUMNS + "WHERE user_id = :userId ORDER BY updated_at DESC, id DESC LIMIT 1")
                .bind("userId", userId)
                .mapToBean(UserAddress.class)
                .findOne()
                .orElse(null);
    }

    private void clearDefaultAddresses(Handle handle, int userId) {
        handle.createUpdate("UPDATE user_addresses SET is_default = 0 WHERE user_id = :userId")
                .bind("userId", userId)
                .execute();
    }

    private void markDefaultAddress(Handle handle, int userId, int addressId) {
        handle.createUpdate("UPDATE user_addresses SET is_default = 1 WHERE user_id = :userId AND id = :id")
                .bind("userId", userId)
                .bind("id", addressId)
                .execute();
    }

    private void syncUserDefaultAddress(Handle handle, int userId, String fullAddress) {
        handle.createUpdate("UPDATE users SET address = :address WHERE id = :userId")
                .bind("address", fullAddress)
                .bind("userId", userId)
                .execute();
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private void ensureDistrictColumn() {
        if (districtColumnEnsured) {
            return;
        }

        synchronized (UserAddressDao.class) {
            if (districtColumnEnsured) {
                return;
            }

            jdbi.useHandle(handle -> {
                int columnCount = handle.createQuery(
                                "SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS "
                                        + "WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'user_addresses' AND COLUMN_NAME = 'district'")
                        .mapTo(Integer.class)
                        .one();

                if (columnCount == 0) {
                    handle.createUpdate("ALTER TABLE user_addresses ADD COLUMN district VARCHAR(255) NULL AFTER ward")
                            .execute();
                }
            });
            districtColumnEnsured = true;
        }
    }

    private String defaultText(String value, String fallback) {
        String trimmed = trim(value);
        return trimmed.isEmpty() ? fallback : trimmed;
    }
}
