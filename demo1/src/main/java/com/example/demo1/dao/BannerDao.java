package com.example.demo1.dao;

import com.example.demo1.model.Banner;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class BannerDao {
    private Jdbi jdbi = DatabaseDao.get();

    public Banner getById(int id) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM banners WHERE id = :id")
                        .bind("id", id)
                        .mapToBean(Banner.class)
                        .findFirst()
                        .orElse(null)
        );
    }

    public int insert(Banner banner) {
        return jdbi.withHandle(handle ->
                handle.createUpdate("INSERT INTO banners (name, start_time, end_time, position, display_order, image) " +
                                "VALUES (:name, :start_time, :end_time, :position, :display_order, :image)")
                        .bindBean(banner)
                        .execute()
        );
    }

    public int update(Banner banner) {
        return jdbi.withHandle(handle ->
                handle.createUpdate("UPDATE banners SET name=:name, start_time=:start_time, end_time=:end_time, " +
                                "position=:position, display_order=:display_order, image=:image " +
                                "WHERE id=:id")
                        .bindBean(banner)
                        .execute()
        );
    }

    public int delete(int id) {
        return jdbi.withHandle(handle ->
                handle.createUpdate("DELETE FROM banners WHERE id = :id")
                        .bind("id", id)
                        .execute()
        );
    }

    public List<Banner> getBannersByPosition(String position) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM banners WHERE position = :position AND NOW() BETWEEN start_time AND end_time ORDER BY display_order ASC")
                        .bind("position", position)
                        .mapToBean(Banner.class)
                        .list()
        );
    }

    public List<Banner> getBanners(String keyword, String position, int limit, int offset) {
        String sql = "SELECT * FROM banners WHERE 1=1 ";

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasPosition = position != null && !position.trim().isEmpty();

        if (hasKeyword) {
            sql += " AND name LIKE :keyword ";
        }
        if (hasPosition) {
            sql += " AND position = :position ";
        }

        sql += "ORDER BY id DESC LIMIT :limit OFFSET :offset";

        final String finalSql = sql;
        return jdbi.withHandle(handle -> {
            var query = handle.createQuery(finalSql)
                    .bind("limit", limit)
                    .bind("offset", offset);

            if (hasKeyword) {
                query.bind("keyword", "%" + keyword + "%");
            }
            if (hasPosition) {
                query.bind("position", position);
            }

            return query.mapToBean(Banner.class).list();
        });
    }

    public int countBanners(String keyword, String position) {
        String sql = "SELECT COUNT(*) FROM banners WHERE 1=1 ";

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasPosition = position != null && !position.trim().isEmpty();

        if (hasKeyword) {
            sql += " AND name LIKE :keyword ";
        }
        if (hasPosition) {
            sql += " AND position = :position ";
        }

        final String finalSql = sql;
        return jdbi.withHandle(handle -> {
            var query = handle.createQuery(finalSql);

            if (hasKeyword) {
                query.bind("keyword", "%" + keyword + "%");
            }
            if (hasPosition) {
                query.bind("position", position);
            }

            return query.mapTo(Integer.class).one();
        });
    }

    public boolean isNameExists(String name, String position, int excludeId) {
        return jdbi.withHandle(handle -> {
            String sql = "SELECT COUNT(*) FROM banners WHERE name = :name";
            if (excludeId > 0) {
                sql += " AND id != :id";
            }
            var query = handle.createQuery(sql)
                    .bind("name", name);
            if (excludeId > 0) {
                query.bind("id", excludeId);
            }
            return query.mapTo(Integer.class).one() > 0;
        });
    }

    public boolean isDisplayOrderExists(String position, int displayOrder, int excludeId) {
        return jdbi.withHandle(handle -> {
            String sql = "SELECT COUNT(*) FROM banners WHERE position = :position AND display_order = :displayOrder";
            if (excludeId > 0) {
                sql += " AND id != :id";
            }
            var query = handle.createQuery(sql)
                    .bind("position", position)
                    .bind("displayOrder", displayOrder);
            if (excludeId > 0) {
                query.bind("id", excludeId);
            }
            return query.mapTo(Integer.class).one() > 0;
        });
    }

    public void shiftDisplayOrders(String position, int fromOrder) {
        jdbi.useHandle(handle ->
                handle.createUpdate("UPDATE banners SET display_order = display_order + 1 " +
                                "WHERE position = :position AND display_order >= :fromOrder")
                        .bind("position", position)
                        .bind("fromOrder", fromOrder)
                        .execute()
        );
    }
}