<%@ Page Title="Contact" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="M4Website.Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <main aclass=" body-content class=container-bg ">
        <section class="contact-page">
            <div class="container">
                <!-- Header -->
                <div class="contact-header">
                    <h2 class="contact-title">Contact Us</h2>
                    <p class="contact-subtitle">
                        We’re here to help! Get in touch with KwaMshana Café for meal subscriptions, catering, or general inquiries.
                    </p>
                </div>

                <!-- Info Strip -->
                <div class="contact-info">
                    <div class="contact-box">
                        <div class="contact-icon"><i class="fas fa-phone-square"></i></div>
                        <h4 class="contact-label">Phone</h4>
                        <p class="contact-text">+27 645 046 994</p>
                    </div>

                    <div class="contact-box">
                        <div class="contact-icon"><i class="fas fa-envelope-square"></i></div>
                        <h4 class="contact-label">Email</h4>
                        <p class="contact-text">kwamshanacafe02@gmail.com</p>
                    </div>

                    <div class="contact-box">
                        <div class="contact-icon"><i class="fas fa-map-marker"></i></div>
                        <h4 class="contact-label">Address</h4>
                        <p class="contact-text">
                            277 Rick Turner Road, Gate 7<br>
                            UKZN Howard College, Durban
                        </p>
                    </div>
                </div>

                <!-- Map -->
                <div class="contact-map">
                    <iframe
                        src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3585.186049741741!2d30.9756!3d-29.8685!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x1ef707d2c3c0e9df%3A0x89f1f76c07d28e48!2s277%20Rick%20Turner%20Rd%2C%20Glenmore%2C%20Durban%2C%204001!5e0!3m2!1sen!2za!4v1694112345678!5m2!1sen!2za"
                        width="100%" height="400" style="border: 0;" allowfullscreen="" loading="lazy"
                        referrerpolicy="no-referrer-when-downgrade"></iframe>
                </div>
            </div>
        </section>
    </main>
</asp:Content>
