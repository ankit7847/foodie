<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login/Register</title>
        <link rel="stylesheet" href="login.css">
        <link rel="icon" href="./Images/Restaurants/download.png" type="image/icon type">
    </head>
<body>
    
  <div class="container">
      <div class="loginbg">
          <div class="box signin">
              <h2>Already Have an Account ?</h2>
              <button class="signinbtn">Sign in</button>
          </div>
          <div class="box signup">
            <h2>Don't Have an Account ?</h2>
            <button class="signupbtn">Sign up</button>
          </div>
      </div>
      <div class="formbx">
        <div class="form signinform">
            <form action="login" method="post">
                <h2>Foodies</h2>
                <h3>Sign In</h3>
                <input type="text" name="email" placeholder="Email Id">
                <input type="password" name="pwd" placeholder="Password">
                <a>
                <input type="submit" value="Login">
                </a>
                <a href="#" class="forgot">Forgot password?</a>
            </form>
        </div>
        <div class="form signupform">
            <form action="register" method="post">
                <h3>Sign up</h3>
                <input type="text" name="name" placeholder="Enter Your Name">
                <input type="text" name="email" placeholder="Email">
                <input type="password" name="pwd" placeholder="Password">
                <input type="password" placeholder="Confirm password">
                <input type="submit" value="Sign Up">
            </form>
        </div>
      </div>
      </div>
<script>
    const signinbtn = document.querySelector('.signinbtn');
    const signupbtn = document.querySelector('.signupbtn');
    const formbx = document.querySelector('.formbx'); 
    const body = document.querySelector('body')

    signupbtn.onclick = function(){
        formbx.classList.add('active')
        body.classList.add('active')
    }
    signinbtn.onclick = function(){
        formbx.classList.remove('active')
        body.classList.remove('active')
    }
    </script>
      
</body>
