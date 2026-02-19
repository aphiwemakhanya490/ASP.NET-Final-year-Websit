<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="M4Website.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <section class="hero">
        <video autoplay muted loop playsinline="true">
            <source src="Vid/HRWS.mp4" type="video/mp4">
            Your browser does not support the video tag.
        </video>
        <div class="overlay"></div>

    <div class="hero-content">
        <h1>Welcome to KwaMshana Cafe</h1>
        <p>Delicious meals made with love and served with passion</p>
        <div class="hero-actions">
            <a href="#services" class="btn btn-primary">Get Started</a>
            <a href="About.aspx" class="btn btn-secondary">Learn More</a>
        </div>
    </div>
    </section>
    <section class="container body-content bg-light">
        <section class="services">
            <h2 class="section-title-hm">What We Do</h2>
            <p class="section-subtitle">
                At KwaMshana Café, we serve delicious meals with flexible options —
                whether you need catering for a big event, a monthly meal plan, or
                a quick daily order, we’ve got you covered.
            </p>
            <div class="cards">
                <!-- Card 1 -->
                <div class="card">
                    <img src="Img/Services/Catering.jpg" />
                    <div class="card-content">
                        <h3>Catering Services</h3>
                        <p>
                            We provide catering for weddings, corporate events,school and
                            special occasions with customizable menus.
                        </p>
                        <a href="Img/PlaneAndMenus/cat.jpg" class="card-link">Explore Catering →</a>
                    </div>    
                </div>

                <!-- Card 2 -->
                <div class="card">
                    <img src="Img/Services/Meal-Sub.jpg" />
                    <div class="card-content">
                        <h3>Meal Subscriptions</h3>
                        <p>
                            Affordable monthly meal plans for students and workers. Healthy,
                            tasty, and delivered on time.
                        </p>
                        <a href="Img/PlaneAndMenus/3772210611035218447-d.jpg"" class="card-link">View Meal Plans →</a>
                    </div>
                </div>

                <!-- Card 3 -->
                <div class="card">
                    <img src="Img/Services/Daily-Meals.jpg" />
                    <div class="card-content">
                        <h3>Daily Orders</h3>
                        <p>
                            Order your favorite meals every day—fast, fresh, and convenient.
                             Walk-in or get it delivered.
                        </p>
                        <a href="Img/PlaneAndMenus/481686721_17939593172974733_404893883651403948_n.jpg" class="card-link">View Menu →</a>
                    </div>
                </div>
            </div>
        </section>
    </section>
    <section class="about-bg">
        <section class="about-us container body-content">
            <div class="about-container about-container-bg">
                <!-- Image -->
                <div class="about-image">
                    <img src="Img/Staff/staff.jpg" />
                </div>

                <!-- Text -->
                <div class="about-text">
                    <h2>About KwaMshana Café</h2>
                    <p>
                        KwaMshana Café is more than just a café —
                        KwaMshana is a testament to the power of female leadership and Black ownership in Durban.
                    </p>
                    <p>
                        We’re driven by compassion and a passion for innovation, with a team of incredible women whose diverse journeys enrich everything we create. 
                        Whether you’re joining us for a comforting daily meal or entrusting us with your special 
                        event, our Mbokodo’s are dedicated to serving you with heart and excellence.
                    </p>

                    <a href="About.aspx" class="about-cta">Learn More About Us→</a>
                </div>
            </div>
        </section>
    </section>
    
    <section class="contact-bg">
        <section class="contact container " id="contact">
            <div class="contact-container">
                <!-- Left: Info -->
                <div class="contact-info info-box">
                    <h2>Get in Touch</h2>
                    <p>
                        Have questions about our catering, meal plans, or daily orders?  
        We’d love to hear from you.
                    </p>
                    <ul>
                        <li><strong>Phone:</strong> 064 504 6994</li>
                        <li><strong>Email:</strong>kwamshana02@gmail.com</li>
                        <li><strong>Address:</strong> 277 Rick Turner Road, Durban, KwaZulu-Natal 4001 (Howard College)</li>
                    </ul>

                    <div class="contact-socials">
                        <a href="https://www.linkedin.com/company/kwamshana-cafe" target="_blank" class="social-icon"><i class="fab fa-linkedin"></i></a>
                        <a href="https://www.tiktok.com/@kwamshana.cafe?is_from_webapp=1&sender_device=pc" target="_blank" class="social-icon"><i class="fab fa-tiktok"></i></a>
                        <a href="https://www.instagram.com/kwamshana.cafe?utm_source=ig_web_button_share_sheet&igsh=cXE2ZWl4Y2R3Y2dl" target="_blank" class="social-icon">
                            <i class="fab fa-instagram"></i>
                        </a>
                    </div>
                </div>

                <!-- Right: Map -->
                <div class="contact-map">
                    <iframe
                       src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3459.788420215364!2d30.97485!3d-29.86605!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x1ef700b77b57b9ad%3A0x19de282a2c95ae43!2s277%20Rick%20Turner%20Rd%2C%20Glenmore%2C%20Durban%2C%204001%2C%20South%20Africa!5e0!3m2!1sen!2sza!4v1694129999999"
                        width="100%" height="100%" style="border: 0;" allowfullscreen="" loading="lazy"></iframe>
                </div>
            </div>
        </section>

    </section>

</asp:Content>
