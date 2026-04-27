<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feedback | Foodies</title>
    <link rel="stylesheet" href="contact.css">
    <script src="https://kit.fontawesome.com/a076d05399.js"></script>
</head>

<body>

<div class="row">
    <div class="box">
        <h2><i class="fas fa-comments"></i>  We Value Your Feedback</h2>
        <br>
        <h2><i class="fas fa-at"></i> Email: feedback@foodies.com</h2>
        <br>
        <h2><i class="fa fa-map-marker"></i> 5th Floor,<br>Patia, Bhubaneswar,<br>Odisha -751021</h2>
    </div>               
</div>

<div class="contact">
    <h1>Feedback Form</h1>

    <form class="form" action="./thankyou.jsp" id="feedbackForm" method="post">
        <label for="uname">Name:</label>
        <input type="text" class="uname" name="name" placeholder="Enter Your Full Name" required>
        <br>

        <label for="email">Email:</label>
        <input type="email" class="uname" name="email" placeholder="Enter Your Email" required>
        <br>

        <label for="rating">Rating:</label>
        <select name="rating" class="uname" required>
            <option value="">Select Rating</option>
            <option value="5">Excellent ⭐⭐⭐⭐⭐</option>
            <option value="4">Very Good ⭐⭐⭐⭐</option>
            <option value="3">Good ⭐⭐⭐</option>
            <option value="2">Fair ⭐⭐</option>
            <option value="1">Poor ⭐</option>
        </select>
        <br>

        <label for="feedback">Your Feedback:</label>
        <textarea name="feedback" class="formtext" cols="50" rows="10" placeholder="Write your feedback here..." required></textarea>
        <br>

        <input type="submit" class="submit" value="Submit Feedback" onclick="resetForm()">
    </form>
</div>

<script>
function resetForm() {
    alert("Thank you for your feedback!");
    document.getElementById("feedbackForm").reset();
}
</script>

</body>
</html>
