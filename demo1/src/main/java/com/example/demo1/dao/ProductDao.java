package com.example.demo1.dao;

import com.example.demo1.model.Product;
import com.example.demo1.model.ProductPage;
import org.jdbi.v3.core.Handle;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.statement.Query;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ProductDao {
    private final Jdbi jdbi = DatabaseDao.get();

    private static final String SELECT_PRODUCT_FIELDS =
            "p.id, p.category_id AS categoryId, p.brand_id AS brandId, p.name, p.discount_id AS discountId, p.description, p.stock, p.image, p.created_at, p.status, " +
                    "p.old_price AS oldPrice, " +
                    "(CASE WHEN d.id IS NOT NULL AND NOW() BETWEEN d.start_time AND d.end_time THEN p.price ELSE p.old_price END) AS price, " +
                    "p.sold_quantity AS soldQuantity, " +
                    "(CASE WHEN d.id IS NOT NULL AND NOW() BETWEEN d.start_time AND d.end_time THEN d.discount_value ELSE 0 END) AS discountValue, " +
                    "d.start_time AS discountStart, " +
                    "d.end_time AS discountEnd, " +
                    "IFNULL(ROUND(AVG(r.rating), 1), 0) AS avgRating ";

    private static class QueryParts {
        String whereSql;
        String joinSql;
        Map<String, Object> params;

        QueryParts(String whereSql, String joinSql, Map<String, Object> params) {
            this.whereSql = whereSql;
            this.joinSql = joinSql;
            this.params = params;
        }
    }

    private QueryParts buildQueryParts(Integer categoryId, String status, String keyword, Integer brandId, Map<Integer, List<String>> specFilters) {
        StringBuilder whereSql = new StringBuilder(" WHERE 1=1 ");
        Map<String, Object> params = new HashMap<>();
        String joinSql = "";

        if (specFilters != null && !specFilters.isEmpty()) {
            joinSql = " JOIN product_specs ps ON p.id = ps.product_id ";
        }

        if (categoryId != null) {
            whereSql.append(" AND p.category_id = :categoryId");
            params.put("categoryId", categoryId);
        }
        if (status != null && !status.isEmpty()) {
            whereSql.append(" AND p.status = :status");
            params.put("status", status);
        } else {
            whereSql.append(" AND p.status != 'delete'");
        }
        if (keyword != null && !keyword.isEmpty()) {
            whereSql.append(" AND (LOWER(p.name) LIKE :keyword)");
            params.put("keyword", "%" + keyword.toLowerCase() + "%");
        }
        if (brandId != null) {
            whereSql.append(" AND p.brand_id = :brandId");
            params.put("brandId", brandId);
        }

        if (specFilters != null && !specFilters.isEmpty()) {
            StringBuilder specConditions = new StringBuilder();
            int i = 0;
            for (Map.Entry<Integer, List<String>> entry : specFilters.entrySet()) {
                if (i > 0) specConditions.append(" OR ");
                String paramName = "spec_values_" + entry.getKey();
                specConditions.append("(ps.attribute_id = ").append(entry.getKey())
                        .append(" AND ps.spec_value IN (<").append(paramName).append(">))");
                i++;
            }
            whereSql.append(" AND (").append(specConditions).append(")");
        }

        return new QueryParts(whereSql.toString(), joinSql, params);
    }

    private int countTotalProducts(Handle handle, QueryParts parts, Map<Integer, List<String>> specFilters) {
        String countSql = "SELECT COUNT(DISTINCT p.id) FROM products p " + parts.joinSql + parts.whereSql;
        Query queryCount = handle.createQuery(countSql).bindMap(parts.params);

        if (specFilters != null) {
            for (Map.Entry<Integer, List<String>> entry : specFilters.entrySet()) {
                queryCount.bindList("spec_values_" + entry.getKey(), entry.getValue());
            }
        }
        return queryCount.mapTo(Integer.class).one();
    }

    private List<Product> getProductsForPage(Handle handle, QueryParts parts, Map<Integer, List<String>> specFilters, String sortOrder, int page, int pageSize) {
        StringBuilder dataSql = new StringBuilder("SELECT " + SELECT_PRODUCT_FIELDS + " FROM products p ");
        dataSql.append(" LEFT JOIN discounts d ON p.discount_id = d.id ");
        dataSql.append(" LEFT JOIN reviews r ON p.id = r.product_id ");
        dataSql.append(parts.joinSql).append(parts.whereSql);
        dataSql.append(" GROUP BY p.id ");

        if (specFilters != null && !specFilters.isEmpty()) {
            dataSql.append(" HAVING COUNT(DISTINCT ps.attribute_id) = ").append(specFilters.size());
        }

        appendOrderBy(dataSql, sortOrder);

        dataSql.append(" LIMIT :limit OFFSET :offset");

        Query queryData = handle.createQuery(dataSql.toString())
                .bindMap(parts.params)
                .bind("limit", pageSize)
                .bind("offset", (page - 1) * pageSize);

        if (specFilters != null) {
            for (Map.Entry<Integer, List<String>> entry : specFilters.entrySet()) {
                queryData.bindList("spec_values_" + entry.getKey(), entry.getValue());
            }
        }

        return queryData.mapToBean(Product.class).list();
    }

    private void appendOrderBy(StringBuilder sql, String sortOrder) {
        String orderBy;
        switch (sortOrder) {
            case "price_asc":
                orderBy = " ORDER BY p.price ASC, p.id ASC ";
                break;
            case "price_desc":
                orderBy = " ORDER BY p.price DESC, p.id DESC ";
                break;
            case "name_asc":
                orderBy = " ORDER BY p.name ASC, p.id ASC ";
                break;
            case "popular":
                orderBy = " ORDER BY p.sold_quantity DESC, p.id DESC ";
                break;
            default:
                orderBy = " ORDER BY p.created_at DESC, p.id DESC ";
                break;
        }
        sql.append(orderBy);
    }

    public ProductPage filterAndSortProducts(Integer categoryId, String status, String keyword, Integer brandId, Map<Integer, List<String>> specFilters, String sortOrder, int page, int pageSize) {
        return jdbi.withHandle(handle -> {
            QueryParts queryParts = buildQueryParts(categoryId, status, keyword, brandId, specFilters);

            if ("popular".equals(sortOrder)) {
                queryParts.whereSql += " AND p.sold_quantity >= 0 ";
            }

            int totalProducts = countTotalProducts(handle, queryParts, specFilters);

            List<Product> products = new ArrayList<>();
            if (totalProducts > 0) {
                products = getProductsForPage(handle, queryParts, specFilters, sortOrder, page, pageSize);
            }

            return new ProductPage(products, totalProducts);
        });
    }

    public Product getById(int productId) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT " + SELECT_PRODUCT_FIELDS +
                                "FROM products p " +
                                "LEFT JOIN discounts d ON p.discount_id = d.id " +
                                "LEFT JOIN reviews r ON p.id = r.product_id " +
                                "WHERE p.id = :id AND p.status != 'delete' " +
                                "GROUP BY p.id")
                        .bind("id", productId)
                        .mapToBean(Product.class)
                        .findOne()
        ).orElse(null);
    }
    public Product getById(int productId, String status) {
        String sql = "SELECT " + SELECT_PRODUCT_FIELDS +
                "FROM products p " +
                "LEFT JOIN discounts d ON p.discount_id = d.id " +
                "LEFT JOIN reviews r ON p.id = r.product_id " +
                "WHERE p.id = :id AND p.status = :status " +
                "GROUP BY p.id";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("id", productId)
                        .bind("status", status)
                        .mapToBean(Product.class)
                        .findOne()
        ).orElse(null);
    }

    public List<Product> getRelatedProducts(int categoryId, int currentProductId, int limit, int offset) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT " + SELECT_PRODUCT_FIELDS +
                                "FROM products p " +
                                "LEFT JOIN discounts d ON p.discount_id = d.id " +
                                "LEFT JOIN reviews r ON p.id = r.product_id " +
                                "WHERE p.category_id = :categoryId AND p.id != :currentProductId AND p.status = 'active' AND p.status != 'delete' " +
                                "GROUP BY p.id " +
                                "ORDER BY p.created_at DESC " +
                                "LIMIT :limit OFFSET :offset")
                        .bind("categoryId", categoryId)
                        .bind("currentProductId", currentProductId)
                        .bind("limit", limit)
                        .bind("offset", offset)
                        .mapToBean(Product.class)
                        .list()
        );
    }
    
    public int countProductsByBrandId(int brandId) {
        return jdbi.withHandle(handle -> {
            QueryParts queryParts = buildQueryParts(null, null, null, brandId, null);
            return countTotalProducts(handle, queryParts, null);
        });
    }
    
    public int countProductsByCategoryId(int categoryId) {
        return jdbi.withHandle(handle -> {
            QueryParts queryParts = buildQueryParts(categoryId, null, null, null, null);
            return countTotalProducts(handle, queryParts, null);
        });
    }

    public int addProductAndReturnId(Product product) {
        return jdbi.inTransaction(handle -> {
            String sql = "INSERT INTO products (category_id, brand_id, name, description, stock, old_price, price, discount_id, status, image) " +
                    "VALUES (:categoryId, :brandId, :name, :description, :stock, :oldPrice, :price, :discountId, :status, :image)";

            return handle.createUpdate(sql)
                    .bindBean(product)
                    .executeAndReturnGeneratedKeys("id")
                    .mapTo(Integer.class)
                    .one();
        });
    }

    public void update(Product product) {
        jdbi.useHandle(handle ->
                handle.createUpdate("UPDATE products SET " +
                                "category_id = :categoryId, " +
                                "brand_id = :brandId, " +
                                "name = :name, " +
                                "description = :description, " +
                                "stock = :stock, " +
                                "old_price = :oldPrice, " +
                                "price = :price, " +
                                "discount_id = :discountId, " +
                                "status = :status, " +
                                "image = :image " +
                                "WHERE id = :id")
                        .bindBean(product)
                        .execute());
    }

    public void delete(int productId) {
        jdbi.useHandle(handle ->
                handle.createUpdate("DELETE FROM products WHERE id = :id")
                        .bind("id", productId)
                        .execute());
    }

    public List<Product> getRandomProducts(int limit) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM products WHERE status = 'active' AND status != 'delete' ORDER BY RAND() LIMIT :limit")
                        .bind("limit", limit)
                        .mapToBean(Product.class)
                        .list()
        );
    }

    public void incrementSoldQuantity(int productId, int quantity) {
        jdbi.useHandle(handle ->
                handle.createUpdate("UPDATE products SET sold_quantity = sold_quantity + :qty WHERE id = :id")
                        .bind("qty", quantity)
                        .bind("id", productId)
                        .execute()
        );
    }

    public void incrementStock(int productId, int quantity) {
        jdbi.useHandle(handle -> {
            handle.createUpdate("UPDATE products SET stock = stock + :qty WHERE id = :id")
                    .bind("qty", quantity)
                    .bind("id", productId)
                    .execute();
            handle.createUpdate("UPDATE products SET status = 'active' WHERE id = :id AND stock > 0 AND status = 'inactive'")
                    .bind("id", productId)
                    .execute();
        });
    }

    public List<Product> searchByNameForSuggestion(String keyword, int limit) {

        String sql = "SELECT id, name, price, image, old_price FROM products " +
                "WHERE status = 'active' AND LOWER(name) LIKE :keyword " +
                "ORDER BY sold_quantity DESC " +
                "LIMIT :limit";

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("keyword", "%" + keyword.toLowerCase() + "%")
                        .bind("limit", limit)
                        .mapToBean(Product.class)
                        .list()
        );
    }

    public int getActiveProductsCount() {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM products WHERE status = 'active'")
                        .mapTo(Integer.class)
                        .one()
        );
    }

    public boolean isProductNameExistsInCategory(String productName, int categoryId, int excludeProductId) {
        return jdbi.withHandle(handle -> {
            StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM products WHERE name = :productName AND category_id = :categoryId");
            if (excludeProductId > 0) {
                sql.append(" AND id != :excludeProductId");
            }
            sql.append(" AND status != 'delete'");
            Query query = handle.createQuery(sql.toString())
                    .bind("productName", productName)
                    .bind("categoryId", categoryId);
            if (excludeProductId > 0) {
                query.bind("excludeProductId", excludeProductId);
            }
            return query.mapTo(Integer.class).one() > 0;
        });
    }
}
