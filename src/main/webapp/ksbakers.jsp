<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>KS | Bakers</title>
    <link rel="icon" href="./Images/Restaurants/download.png" type="image/icon type">
<link rel="stylesheet" href="ksbakers.css">
<script src="https://kit.fontawesome.com/a076d05399.js"></script>
</head>
<body>
    
    <!--Header section start-->
    <header>
        <a href="#" class="logo"><i class="fa fa-utensils"></i>Foodies.</a>
        <nav class="navbar">
            <a class="active" href="./index.jsp">Home</a>
            <a href="./food_types.jsp">dishes</a>
            <a href="./contact.jsp" >Contact us</a>
             <a href="./cart.jsp" >My Cart</a>
            <a href="#">Orders</a>
        </nav>
        <div class="icons">
            <i class="fas fa-bars" id="menu-bars"></i>
            <i class="fas fa-search" id="search-icon"></i>
            <a href="#" class="fas fa-heart"></a>
            <a href="#" class="fas fa-shopping-cart"></a>
            <i class="fa fa-user" aria-hidden="true"></i>
            <a href="login.jsp" class="fas fa-sign-in-alt"></a>
            
        </div>

         <!--search form-->
    <form action="" id="search-form">
        <input type="search" placeholder="search here..." name="" id="search-box">
        <label for="search-box" class="fas fa-search"></label>
        <i class="fas fa-times" id="close1"></i>
    </form>
    <!--Search Form ends-->
    </header>

<!--Rating Form starts-->

<div class="back">
    <div class="container1" id="co1">
        <div class="post">
            <div class="text">Thanks for Rating us!</div>
            <div class="edit">Edit</div>
            <i class="fas fa-times" id="close"></i>
    
        </div>
        <div class="star-widget">
        <input type="radio" name="rate" id="rate-5">
        <label for="rate-5" class="fas fa-star"></label>
        <input type="radio" name="rate" id="rate-4">
        <label for="rate-4" class="fas fa-star"></label>
        <input type="radio" name="rate" id="rate-3">
        <label for="rate-3" class="fas fa-star"></label>
        <input type="radio" name="rate" id="rate-2">
        <label for="rate-2" class="fas fa-star"></label>
        <input type="radio" name="rate" id="rate-1">
        <label for="rate-1" class="fas fa-star"></label>
        <form action="#">
            <i class="fas fa-times" id="close"></i>
            <h4></h4>
            <div class="textarea">
                <textarea cols="30" placeholder="Describe your experience"></textarea>
    
            </div>
            
            <div class="btn">
                <button type="submit">Post</button>
            </div>
        </form>
        </div>    
    </div>
    </div>
<!--Rating form ends-->
<!--side bar-->

<nav class="sidebar">
    <div class="text">
    <a href="./ksbakers.jsp"><i class="fa fa-home"></i></a>
    <ul>
        <li><a href="#cakes" onclick="myfun()">Regular Cakes</a></li>
        <li><a href="#precakes" onclick="myfunction()">Premium Cakes</a></li>
        <li><a href="#pastry" onclick="mypastry()">Pastries</a></li>
        <li><a href="#burger" onclick="myburger()">Burgers</a></li>
        <li><a href="#bread" onclick="mybread()">Bread</a></li>
       
        
        

    </ul>
</div>
</nav>
<!--Side bar ends-->

<section class="home" id="home">
    <div class="barb">
    <h2><img src="./Images/Restaurants/ksbakers.png" height="350"></h2>
    
        </div>
</section>
<section class="meh" id="cakes">
    <h2 class="ks">KS Bakers</h2>
    <hr class="line">
    <h4>Regular Cakes</h4>  
    <div class="box-container">
    <div class="box">
        <img src="./Images/Dishes/eggless-pineapple.jpg">
        <h3>Egg-less pineapple cake 1kg</h3>
        <div class="stars">
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star-half-alt"></i>

        </div>
        <span>₹704</span>
        <br>
        <a href="#" class="btn">Add to cart</a>
    </div>
    
    <div class="box">
        <img src="./Images/Dishes/blackforest.jpg">
        <h3>Black Forest 1kg</h3>
        <div class="stars">
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star-half-alt"></i>
        </div>
        <span>₹688</span>
        <br>
        <a href="#" class="btn">Add to cart</a>

    </div>
    <div class="box">
        <img src="./Images/Dishes/eggless-buterscotch.jpg">
        <h3>Egg-less Buterscotch 1kg</h3>
        <div class="stars">
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star-half-alt"></i>
        </div>
        <span>₹720</span>
        <br>
        <a href="#" class="btn">Add to cart</a>

    </div>
    <div class="box">
        <img src="./Images/Dishes/egg-less blackforest.JPG" >
        <h3>Egg less blackforest 1kg</h3>
        <div class="stars">
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star-half-alt"></i>
        </div>
        <span>₹140</span>
        <br>
        <a href="#" class="btn">Add to cart</a>

    </div>
    <div class="box">
        <img src="./Images/Dishes/butter-scotch.jpg">
        <h3>Butter Scotch cake 1kg</h3>
        <div class="stars">
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star-half-alt"></i>
        </div>
        <span>₹660</span>
        <br>
        <a href="#" class="btn">Add to cart</a>

    </div>
    
    </div>
    
</section><section class="pre" id="precakes">
    <h2 class="ks">KS Bakers</h2>
    <hr class="line">
    <h4>Premium Cakes</h4>  
    <div class="box-precake">
        <div class="box">
            <img src="./Images/Dishes/angry bird cake.jpg">
            <h3>Angry Bird cake</h3>
            <div class="stars">
                <i class="fas fa-star"></i>
                <i class="fas fa-star"></i>
                <i class="fas fa-star"></i>
                <i class="fas fa-star"></i>
                <i class="fas fa-star-half-alt"></i>
    
            </div>
            <span>₹180</span>
            <br>
            <a href="#" class="btn">Add to cart</a>
        </div>
    <div class="box">
        <img src="./Images/Dishes/rasmalai cake.jpg">
        <h3>Rasmalai cake 1kg</h3>
        <div class="stars">
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star-half-alt"></i>

        </div>
        <span>₹1204</span>
        <br>
        <a href="#" class="btn">Add to cart</a>
    </div>
    <div class="box">
        <img src="./Images/Dishes/almond delight.jpg">
        <h3>Almond delight cake 1kg</h3>
        <div class="stars">
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star-half-alt"></i>

        </div>
        <span>₹968</span>
        <br>
        <a href="#" class="btn">Add to cart</a>
    </div>
    
    
    <div class="box">
        <img src="./Images/Dishes/gulab-jamun-cake1.jpg" >
        <h3>Gulab Jamun cake 1kg</h3>
        <div class="stars">
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star-half-alt"></i>
        </div>
        <span>₹1108</span>
        <br>
        <a href="#" class="btn">Add to cart</a>

    </div>
    <div class="box">
        <img src="./Images/Dishes/red-velvet cake.jpg">
        <h3>Red velvet cake 1/2kg</h3>
        <div class="stars">
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star-half-alt"></i>
        </div>
        <span>₹540</span>
        <br>
        <a href="#" class="btn">Add to cart</a>

    </div>
    
    </div>
    
</section>
<section class="past" id="pastry">
    <h2 class="ks">KS Bakers</h2>
    <hr class="line">
    <h4>Pastry's</h4>  
    <div class="box-pastry">
    <div class="box">
        <img src="./Images/Dishes/red-velvet pastry.jpg">
        <h3>Red Velvet Pastry</h3>
        <div class="stars">
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star-half-alt"></i>

        </div>
        <span>₹127</span>
        <br>
        <a href="#" class="btn">Add to cart</a>
    </div>
    <div class="box">
        <img src="./Images/Dishes/blackforest pastry.jpg">
        <h3>Black Forest Pastry</h3>
        <div class="stars">
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star-half-alt"></i>

        </div>
        <span>₹73</span>
        <br>
        <a href="#" class="btn">Add to cart</a>
    </div>
    <div class="box">
        <img src="./Images/Dishes/almond delight pastry.webp">
        <h3>almond delight</h3>
        <div class="stars">
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star-half-alt"></i>
        </div>
        <span>₹109</span>
        <br>
        <a href="#" class="btn">Add to cart</a>

    </div>
    
    <div class="box">
        <img src="./Images/Dishes/pineapple pastry.jpg">
        <h3>ButterScotch pastry</h3>
        <div class="stars">
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star-half-alt"></i>
        </div>
        <span>₹73</span>
        <br>
        <a href="#" class="btn">Add to cart</a>

    </div>
    <div class="box">
        <img src="./Images/Dishes/butterscotch pastry.jpg">
        <h3>Pineapple pastry</h3>
        <div class="stars">
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star-half-alt"></i>
        </div>
        <span>₹73</span>
        <br>
        <a href="#" class="btn">Add to cart</a>

    </div>
    
    <div class="box">
        <img src="./Images/Dishes/donut.jpg">
        <h3>Donut</h3>
        <div class="stars">
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star-half-alt"></i>
        </div>
        <span>₹109</span>
        <br>
        <a href="#" class="btn">Add to cart</a>

    </div>
</section>
<section class="burg" id="burger">
    <h2 class="ks">KS Bakers</h2>
    <hr class="line">
    <h4>Burger</h4>  
    <div class="box-burger">
    
    <div class="box">
        <img src="./Images/Dishes/mini-chicken-burger.jpg">
        <h3>Mini Chicken Burger</h3>
        <div class="stars">
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star-half-alt"></i>
        </div>
        <span>₹99</span>
        <br>
        <a href="#" class="btn">Add to cart</a>

    </div>
    <div class="box">
        <img src="./Images/Dishes/paneer-tikka-burger.JPG">
        <h3>Pineapple tikka Burger</h3>
        <div class="stars">
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star-half-alt"></i>
        </div>
        <span>₹121</span>
        <br>
        <a href="#" class="btn">Add to cart</a>

    </div>
    <div class="box">
        <img src="./Images/Dishes/chicken burger.jpg">
        <h3>Chicken Burger</h3>
        <div class="stars">
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star-half-alt"></i>
        </div>
        <span>₹127</span>
        <br>
        <a href="#" class="btn">Add to cart</a>

    </div>
    <div class="box">
        <img src="./Images/Dishes/chicken tika burger.jpg">
        <h3>Chicken Tikka Burger</h3>
        <div class="stars">
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star-half-alt"></i>
        </div>
        <span>₹149</span>
        <br>
        <a href="#" class="btn">Add to cart</a>

    </div>
    
    <div class="box">
        <img src="./Images/Dishes/veg-burger.jpg">
        <h3>Veg burger</h3>hh3>
        <div class="stars">
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star-half-alt"></i>
        </div>
        <span>₹85</span>
        <br>
        <a href="#" class="btn">Add to cart</a>

    </div>
  
    
</section>
<section class="brd" id="bread">
    <h2 class="ks">KS Bakers</h2>
    <hr class="line">
    <h4>Bread</h4>  
    <div class="box-bread">
    <div class="box">
        <img src="./Images/Dishes/dilkush.jpg">
        <h3>Dil Kush</h3>
        <div class="stars">
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star-half-alt"></i>

        </div>
        <span>₹28</span>
        <br>
        <a href="#" class="btn">Add to cart</a>
    </div>
    <div class="box">
        <img src="./Images/Dishes/double ka meetha.jpg">
        <h3>double ka meetha</h3>
        <div class="stars">
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star-half-alt"></i>

        </div>
        <span>₹60</span>
        <br>
        <a href="#" class="btn">Add to cart</a>
    </div>
    <div class="box">
        <img src="./Images/Dishes/creambread.jpg">
        <h3>cream bread</h3>
        <div class="stars">
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star-half-alt"></i>
        </div>
        <span>₹30</span>
        <br>
        <a href="#" class="btn">Add to cart</a>

    </div>
    
    <div class="box">
        <img src="./Images/Dishes/toast.jpg">
        <h3>Toast</h3>
        <div class="stars">
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star-half-alt"></i>
        </div>
        <span>₹99</span>
        <br>
        <a href="#" class="btn">Add to cart</a>

    </div>
    <div class="box">
        <img src="./Images/Dishes/fruit bread.jpg">
        <h3>Fruit Bread</h3>
        <div class="stars">
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star-half-alt"></i>
        </div>
        <span>₹40</span>
        <br>
        <a href="#" class="btn">Add to cart</a>

    </div>
    
    
</section>





>
<div class="arrow">

<a href="#home"><i class="fas fa-arrow-up"></i></a>
</div>
<div id="about" class="about">
    <a href="#" class="closebtn" onclick="closeNav()">&times;</a>
    <div class="about-overlay">
        <h1>About us</h1>
        <p>Launched in 2021, Our technology platform connects customers,<br> 
        restaurant partners and delivery partners, serving their multiple needs. <br>
        Customers use our platform to search and discover restaurants, read and write customer 
        generated reviews and view and upload photos,<br> order food delivery, book a table and make 
        payments while dining-out at restaurants. On the other hand,<br> we provide restaurant partners 
        with industry-specific marketing tools which enable them to engage and acquire customers<br> to 
        grow their business while also providing a reliable <br>and efficient last mile delivery service. 
        We also operate a one-stop procurement solution, <br>Hyperpure, which supplies high quality ingredients 
        and kitchen products to restaurant partners.<br> We also provide our delivery partners with transparent 
        and flexible earning opportunities. </p>
    </div>
</div>
<!--Footer Section-->
<footer class="footer">
    <div class="container">
        <div class="row">
            
            <div class="footer-col">
                <ul>
                    <i class="fa fa-utensils"></i>
                    <span>Foodies.</span>
                </ul>
                <div class="map">
                    <ul>
                        <i class="fa fa-map-marker"></i>
                            <span>5th Floor,
                                Patia,Bhubaneswar, Odisha - 751021
                            </span>
                    </ul>
                    </div>
                <div class="mail">
                    <ul>
                        <i class="fas fa-inbox"></i>
                        <span>
                            support@foodies.com
                        </span>
                    </ul>
                </div>
            </div>
            
            <div class="footer-col">
                <h4>Foodies</h4>
                <ul>
                    <li><a href="#">about us</a></li>
                    <li><a href="#">Our services</a></li>
                    <li><a href="#">Privacy policy</a></li>
                    <li><a href="#">Payment policy</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4>Get help</h4>
                <ul>
                    <li><a href="#">FAQ</a></li>
                    <li><a href="#">Delivery</a></li>
                    <li><a href="#">My orders</a></li>
                    <li><a href="#">Order Status</a></li>
                    <li><a href="#">Payment options</a></li>

                </ul>
                </div>
                <div class="footer-col">
                    <h4>Order Now</h4>
                    <ul>
                        <li><a href="#">Biryani's</a></li>
                        <li><a href="#">Restaurants</a></li>
                        <li><a href="#">Starters</a></li>
                        <li><a href="#">Fast food</a></li>
                    </ul>
                </div>
                <div class="footer-col">
                    <h4>Follow us</h4>
                    <div class="social-links">
                        <a href="#"><i class="fab fa-facebook-f"></i></a>
                        <a href="#"><i class="fab fa-twitter"></i></a>
                        <a href="#"><i class="fab fa-instagram"></i></a>
                        <a href="#"><i class="fab fa-linkedin-in"></i></a>

                    </div>

                </div>

            </div>
            </div>
            

</footer>

<!--Home  ends-->


<!--Java Script-->
<script>
        let menu = document.querySelector('#menu-bars');
        let navbar = document.querySelector('.navbar');
        
        menu.onclick = () => {
            menu.classList.toggle('fa-times');
            navbar.classList.toggle('active');
        }
        window.onscroll=() => {
            menu.classList.remove('fa-times');
            navbar.classList.remove('active');
        }
        document.querySelector('#search-icon').onclick=() => {
            document.querySelector('#search-form').classList.toggle('active');
        }
        document.querySelector('#close1').onclick=() => {
            document.querySelector('#search-form').classList.toggle('active');
        }
        document.querySelector("#feedback").onclick=() =>{
        document.querySelector("#co1").classList.toggle("active");
    }
        document.querySelector("#close").onclick=() =>{
        document.querySelector("#co1").classList.toggle("active");

    }
    function myfun(){
        document.getElementById("cakes").style.display="block";
    }
    function myfunction(){
        document.getElementById("precakes").style.display="block";
    }
    function mypastry(){
        document.getElementById("pastry").style.display="block";
    }
    function myburger(){
        document.getElementById("burger").style.display="block";
    }
    function mybread(){
        document.getElementById("bread").style.display="block";
    }
    function mysandwich(){
        document.getElementById("sandwich").style.display="block";
    }
    function mypizza(){
        document.getElementById("nonpizza").style.display="block";
    }
    
        const btn = document.querySelector("button");
        const post = document.querySelector(".post");
        const widget = document.querySelector(".star-widget");
        const editBtn = document.querySelector(".edit");
    
        btn.onclick = () =>{
        widget.style.display = "none";
        post.style.display = "block";
        editBtn.onclick = () =>{
            widget.style.display = "block";
            post.style.display = "none";
        }
        return false;
    }
      function openAbout(){
        document.getElementById("about").style.width = "100%";

    }
    function closeNav(){
        document.getElementById("about").style.width = "0%";
    }
   
       
</script>
<!--JavaScript ends -->

</body>
</html>