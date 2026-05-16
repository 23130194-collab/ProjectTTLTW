package com.example.demo1.service;

import com.example.demo1.dao.UserAddressDao;
import com.example.demo1.model.User;
import com.example.demo1.model.UserAddress;

import java.util.List;

public class UserAddressService {
    private final UserAddressDao userAddressDao = new UserAddressDao();

    public void ensureDefaultAddressForUser(User user) {
        userAddressDao.ensureDefaultAddressForUser(user);
    }

    public List<UserAddress> getAddressesByUserId(int userId) {
        return userAddressDao.getAddressesByUserId(userId);
    }

    public UserAddress getDefaultAddressByUserId(int userId) {
        return userAddressDao.getDefaultAddressByUserId(userId);
    }

    public UserAddress getAddressById(int userId, int addressId) {
        return userAddressDao.getAddressById(userId, addressId);
    }

    public UserAddress createAddress(UserAddress address) {
        return userAddressDao.createAddress(address);
    }

    public boolean updateAddress(UserAddress address) {
        return userAddressDao.updateAddress(address);
    }

    public boolean deleteAddress(int userId, int addressId) {
        return userAddressDao.deleteAddress(userId, addressId);
    }

    public boolean setDefaultAddress(int userId, int addressId) {
        return userAddressDao.setDefaultAddress(userId, addressId);
    }
}
