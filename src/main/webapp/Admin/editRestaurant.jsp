<%@ page import="java.sql.*,com.db.ConnectionProvider" %>
<%@ page import="java.io.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Restaurant</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container">
        <h2>Edit Restaurant</h2>
        <form action="/FDelivery/UpdateRestaurantServlet" method="post" enctype="multipart/form-data">
            <% 
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                
                try {
                    // Establish database connection
                    conn = ConnectionProvider.getConnection();
                    
                    // Fetch data for the specified restaurant ID
                    String id = request.getParameter("id");
                    String sql = "SELECT restaurant_name, description, restaurant_image FROM restaurants WHERE restaurant_id=?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, id);
                    rs = pstmt.executeQuery();
                    if (rs.next()) {
                        String name = rs.getString("restaurant_name");
                        String description = rs.getString("description");
            %>
            <div class="form-group">
                <label for="restaurantName">Name:</label>
                <input type="text" class="form-control" id="restaurantName" name="restaurantName" value="<%= name %>">
            </div>
            <div class="form-group">
                <label for="description">Description:</label>
                <textarea class="form-control" id="description" name="description"><%= description %></textarea>
            </div>
            <div class="form-group">
                <label for="restaurantImage">Image:</label>
                <input type="file" class="form-control-file" id="restaurantImage" name="restaurantImage">
            </div>
            <input type="hidden" name="id" value="<%= id %>">
            <input type="submit" name="update_data" class="btn btn-primary" value="Update">
            <% 
                    }
                } catch (SQLException ex) {
                    ex.printStackTrace();
                } finally {
                    // Close resources
                    if (rs != null) try { rs.close(); } catch (SQLException ex) { /* ignored */ }
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException ex) { /* ignored */ }
                    if (conn != null) try { conn.close(); } catch (SQLException ex) { /* ignored */ }
                }
            %>
        </form>
    </div>
    <!-- Bootstrap JS -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
