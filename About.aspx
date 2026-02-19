<%@ Page Title="About" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="M4Website.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <main class="about-page">
        <!-- Header -->
        <div class="about-header">
            <section class="container">
                <h1 class="about-title">About KwaMshana Cafe</h1>
                <p class="about-subtitle">Authentic flavors • Local pride • Meals that feel like home</p>
            </section>
        </div>

        <div class="container">
            <!-- Overview -->
            <div class="row">
                <div class="col-lg-12">
                    <h2 class="section-title">Our Story</h2>
                    <div class="info-card">
                        <p>KwaMshana Cafe is a <span class="highlight">100% black-owned company</span> that specializes in providing convenient monthly meals for workers on premium budget. Over the years, the brand has grown with vast experience in serving customers with warm hearty meals.</p>
                        <p>Recently, KwaMshana Cafe launched their <span class="highlight">catering division</span>, offering exclusive packages for all indoor and outdoor events.</p>
                    </div>

                </div>
            </div>

            <!-- Mission & Values -->
            <div class="row mt-4">
                <div class="col-12">
                    <div class="info-card">
                        <h2 class="section-title">Our Mission</h2>
                        <p>
                            At KwaMshana Cafe, our mission goes beyond simply serving food — we aim to 
                <span class="highlight">nourish both body and soul</span>. We are committed to offering 
                 hearty, home-style meals that bring comfort and convenience to the lives of our customers.
                        </p>

                        <p>
                            Through our <span class="highlight">monthly meal subscription service</span>, 
                    we make it easy for students and workers to enjoy fresh, wholesome meals every day 
                    without the stress of cooking or the cost of eating out. Our portions are generous, 
                    our prices are fair, and our menus are designed to remind you of home — 
                    from a warm plate of pap and stew to classic bunny chows that celebrate Durban’s culture.  
                        </p>

                        <p>
                            With the launch of our <span class="highlight">catering division</span>, 
                        we now proudly bring the KwaMshana experience to events of all sizes — 
                    from family celebrations to corporate gatherings. Our catering packages 
                    are designed to deliver delicious food, excellent service, and that 
                    unmistakable South African hospitality that makes every occasion special.  
                        </p>

                        <p>
                            We believe in food that tells a story — a story of tradition, community, and 
                    resilience. By using locally sourced ingredients, supporting small suppliers, 
                    and embracing our rich culinary heritage, we continue to serve meals that 
                    taste like home while creating opportunities within our community.  
                        </p>


                        <h2 class="section-title mt-4">Our Values</h2>
                        <ul class="values-list">
                            <li>✅ Quality ingredients and preparation</li>
                            <li>✅ Exceptional customer service</li>
                            <li>✅ Supporting local communities</li>
                            <li>✅ Preserving culinary traditions</li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- Gallery -->
            <div class="about-gallery">
                <h2 class="section-title">Life at KwaMshana Café</h2>
                <div class="gallery-grid">
                    <img src="Img/LifeAtKwamshana/staff.jpg" />
                    <img src="Img/LifeAtKwamshana/snaptik_7429269054939991302_1.jpeg" />
                    <img src="Img/LifeAtKwamshana/snaptik_7429269054939991302_2.jpeg" />
                    <img src="Img/LifeAtKwamshana/snaptik_7429269054939991302_14.jpeg" />
                    <img src="Img/LifeAtKwamshana/snaptik_7429269054939991302_5.jpeg" />
                    <img src="Img/LifeAtKwamshana/snaptik_7429269054939991302_3.jpeg" />
                    <img src="Img/LifeAtKwamshana/snaptik_7429269054939991302_6.jpeg" />
                    <img src="Img/LifeAtKwamshana/snaptik_7429269054939991302_4.jpeg" />
                </div>
            </div>
        </div>
        <!-- Reviews Section -->
<div class="reviews-section mt-5">
    <div class="container">
        <h2 class="section-title text-center mb-4">Customer Reviews</h2>

        <asp:UpdatePanel ID="upReviews" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <!-- Review Statistics -->
                <div class="review-stats-container">
                    <div class="row align-items-center">
                        <div class="col-md-4 text-center">
                            <div class="average-rating">
                                <h1 class="rating-number">
                                    <asp:Label ID="lblAverageRating" runat="server" Text=""></asp:Label>
                                </h1>
                                <div class="stars">
                                    <asp:Literal ID="litAverageStars" runat="server"></asp:Literal>
                                </div>
                                <p class="review-count">
                                    Based on <asp:Label ID="lblTotalReviews" runat="server" Text=""></asp:Label> reviews
                                </p>
                            </div>
                        </div>
                        <div class="col-md-5">
                            <div class="rating-bars">
                                <asp:Repeater ID="rptRatingBars" runat="server">
                                    <ItemTemplate>
                                        <div class="rating-bar-row">
                                            <div class="stars-label">
                                                <%# Eval("Stars") %> ⭐
                                            </div>
                                            <div class="progress">
                                                <div class="progress-bar bg-warning" 
                                                     role="progressbar" 
                                                     style='width: <%# Eval("Percentage") %>' 
                                                     aria-valuenow='<%# Eval("Percentage") %>' 
                                                     aria-valuemin="0" 
                                                     aria-valuemax="100">
                                                </div>
                                            </div>
                                            <div class="count-label">
                                                <%# Eval("Count") %>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                        <div class="col-md-3 text-center">
                            <asp:Button ID="btnWriteReview" runat="server" 
                                        Text="Write a review" 
                                        CssClass="btn btn-dark btn-lg"
                                        OnClick="btnWriteReview_Click" />
                        </div>
                    </div>
                </div>

                <!-- Filter Dropdown -->
                <div class="review-filter-section mt-4">
                    <asp:DropDownList ID="ddlReviewFilter" runat="server" 
                                      CssClass="form-select review-filter-dropdown"
                                      AutoPostBack="true"
                                      OnSelectedIndexChanged="ddlReviewFilter_SelectedIndexChanged">
                        <asp:ListItem Value="Most Recent" Selected="True">Most Recent</asp:ListItem>
                        <asp:ListItem Value="Highest Rating">Highest Rating</asp:ListItem>
                        <asp:ListItem Value="Lowest Rating">Lowest Rating</asp:ListItem>
                        <asp:ListItem Value="Most Helpful">Most Helpful</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <!-- Write Review Form (Hidden by default) -->
                <asp:Panel ID="pnlWriteReview" runat="server" Visible="false" CssClass="write-review-form mt-4">
                    <div class="review-form-card">
                        <h3 class="mb-4">Write a review</h3>

                        <!-- Star Rating -->
                        <div class="form-group mb-3">
                            <label class="form-label">Rating</label>
                            <div class="star-rating-input">
                                <asp:RadioButtonList ID="rblRating" runat="server" 
                                                     RepeatDirection="Horizontal" 
                                                     CssClass="star-rating-list">
                                    <asp:ListItem Value="5">⭐⭐⭐⭐⭐</asp:ListItem>
                                    <asp:ListItem Value="4">⭐⭐⭐⭐</asp:ListItem>
                                    <asp:ListItem Value="3">⭐⭐⭐</asp:ListItem>
                                    <asp:ListItem Value="2">⭐⭐</asp:ListItem>
                                    <asp:ListItem Value="1">⭐</asp:ListItem>
                                </asp:RadioButtonList>
                                <asp:RequiredFieldValidator ID="rfvRating" runat="server" 
                                                          ControlToValidate="rblRating"
                                                          ErrorMessage="Please select a rating"
                                                          CssClass="text-danger"
                                                          Display="Dynamic"
                                                          ValidationGroup="ReviewForm" />
                            </div>
                        </div>

                        <!-- Review Title -->
                        <div class="form-group mb-3">
                            <label class="form-label">Review Title</label>
                            <asp:TextBox ID="txtReviewTitle" runat="server" 
                                       CssClass="form-control" 
                                       placeholder="Give your review a title"
                                       MaxLength="200"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvTitle" runat="server" 
                                                      ControlToValidate="txtReviewTitle"
                                                      ErrorMessage="Review title is required"
                                                      CssClass="text-danger"
                                                      Display="Dynamic"
                                                      ValidationGroup="ReviewForm" />
                        </div>

                        <!-- Review Text -->
                        <div class="form-group mb-3">
                            <label class="form-label">Review</label>
                            <asp:TextBox ID="txtReviewText" runat="server" 
                                       TextMode="MultiLine" 
                                       Rows="5"
                                       CssClass="form-control" 
                                       placeholder="Write your comments here"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvReviewText" runat="server" 
                                                      ControlToValidate="txtReviewText"
                                                      ErrorMessage="Review text is required"
                                                      CssClass="text-danger"
                                                      Display="Dynamic"
                                                      ValidationGroup="ReviewForm" />
                        </div>

                        <!-- Name -->
                        <div class="form-group mb-3">
                            <label class="form-label">Name (displayed publicly like John Smith)</label>
                            <asp:TextBox ID="txtCustomerName" runat="server" 
                                       CssClass="form-control" 
                                       placeholder="Enter your name (public)"
                                       MaxLength="100"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvName" runat="server" 
                                                      ControlToValidate="txtCustomerName"
                                                      ErrorMessage="Name is required"
                                                      CssClass="text-danger"
                                                      Display="Dynamic"
                                                      ValidationGroup="ReviewForm" />
                        </div>

                        <!-- Email -->
                        <div class="form-group mb-3">
                            <label class="form-label">Email</label>
                            <asp:TextBox ID="txtEmail" runat="server" 
                                       TextMode="Email"
                                       CssClass="form-control" 
                                       placeholder="Enter your email (private)"
                                       MaxLength="255"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" 
                                                      ControlToValidate="txtEmail"
                                                      ErrorMessage="Email is required"
                                                      CssClass="text-danger"
                                                      Display="Dynamic"
                                                      ValidationGroup="ReviewForm" />
                            <asp:RegularExpressionValidator ID="revEmail" runat="server"
                                                          ControlToValidate="txtEmail"
                                                          ErrorMessage="Invalid email format"
                                                          ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                                                          CssClass="text-danger"
                                                          Display="Dynamic"
                                                          ValidationGroup="ReviewForm" />
                            <small class="form-text text-muted">
                                How we use your data: We'll only contact you about the review you left, 
                                and only if necessary. By submitting your review, you agree to our terms, 
                                privacy and content policies.
                            </small>
                        </div>

                        <!-- Buttons -->
                        <div class="form-buttons">
                            <asp:Button ID="btnCancelReview" runat="server" 
                                      Text="Cancel review" 
                                      CssClass="btn btn-outline-dark btn-lg"
                                      OnClick="btnCancelReview_Click"
                                      CausesValidation="false" />
                            <asp:Button ID="btnSubmitReview" runat="server" 
                                      Text="Submit Review" 
                                      CssClass="btn btn-dark btn-lg"
                                      OnClick="btnSubmitReview_Click"
                                      ValidationGroup="ReviewForm" />
                        </div>
                    </div>
                </asp:Panel>

                <!-- Reviews Preview (Top 3) -->
                <asp:Panel ID="pnlReviewsPreview" runat="server" Visible="true">
                    <div class="reviews-preview mt-4">
                        <div class="row">
                            <asp:Repeater ID="rptReviewsPreview" runat="server">
                                <ItemTemplate>
                                    <div class="col-md-4 mb-4">
                                        <div class="review-card">
                                            <div class="review-header">
                                                <div class="stars">
                                                    <%# GetStarRating(Convert.ToInt32(Eval("Rating"))) %>
                                                </div>
                                                <div class="review-date">
                                                    <%# Convert.ToDateTime(Eval("ReviewDate")).ToString("dd/MM/yyyy") %>
                                                </div>
                                            </div>
                                            <div class="reviewer-info">
                                                <div class="reviewer-icon">
                                                    <i class="fas fa-user-circle"></i>
                                                </div>
                                                <div class="reviewer-details">
                                                    <strong><%# Eval("CustomerName") %></strong>
                                                    <%# Convert.ToBoolean(Eval("IsVerified")) ? "<span class='verified-badge'>Verified</span>" : "" %>
                                                </div>
                                            </div>
                                            <h5 class="review-title"><%# Eval("ReviewTitle") %></h5>
                                            <p class="review-text"><%# Eval("ReviewText") %></p>
                                            <a href="#" class="read-more-link" 
                                               onclick="return showFullReview(<%# Eval("ReviewID") %>);">
                                                Full Review
                                            </a>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>

                    <div class="text-center mt-4">
                        <asp:Button ID="btnReadMoreReviews" runat="server" 
                                  Text="Read More Reviews" 
                                  CssClass="btn btn-outline-dark btn-lg"
                                  OnClick="btnReadMoreReviews_Click" />
                    </div>
                </asp:Panel>

                <!-- All Reviews (Hidden by default) -->
                <asp:Panel ID="pnlAllReviews" runat="server" Visible="false" CssClass="all-reviews-section mt-4">
                    <asp:Repeater ID="rptAllReviews" runat="server">
                        <ItemTemplate>
                            <div class="review-card-full mb-4">
                                <div class="row">
                                    <div class="col-12">
                                        <div class="review-header-full">
                                            <div class="stars-large">
                                                <%# GetStarRating(Convert.ToInt32(Eval("Rating"))) %>
                                            </div>
                                            <div class="review-date-large">
                                                <%# Convert.ToDateTime(Eval("ReviewDate")).ToString("dd/MM/yyyy") %>
                                            </div>
                                        </div>
                                        <div class="reviewer-info-full">
                                            <div class="reviewer-icon-large">
                                                <i class="fas fa-user-circle"></i>
                                            </div>
                                            <div class="reviewer-details-full">
                                                <strong><%# Eval("CustomerName") %></strong>
                                                <%# Convert.ToBoolean(Eval("IsVerified")) ? "<span class='verified-badge'>Verified</span>" : "" %>
                                            </div>
                                        </div>
                                        <h4 class="review-title-full"><%# Eval("ReviewTitle") %></h4>
                                        <p class="review-text-full"><%# Eval("ReviewText") %></p>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </asp:Panel>

            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</div>

<!-- SQL DataSource (Optional - if you prefer using SqlDataSource) -->
        <asp:SqlDataSource ID="sqlReviews" runat="server"
            ConnectionString='<%$ ConnectionStrings:WstGrp31ConnectionString %>'
            SelectCommand="sp_GetApprovedReviews"
            SelectCommandType="StoredProcedure">
</asp:SqlDataSource>

<!-- CSS Styles for Reviews Section -->
<style>
    .reviews-section {
        background: #f8f9fa;
        padding: 4rem 0;
        margin-top: 3rem;
    }

    .review-stats-container {
        background: white;
        padding: 2rem;
        border-radius: 15px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        margin-bottom: 2rem;
    }

    .average-rating .rating-number {
        font-size: 4rem;
        font-weight: 700;
        color: #333;
        margin: 0;
    }

    .average-rating .stars {
        font-size: 1.5rem;
        color: #ffc107;
        margin: 0.5rem 0;
    }

    .average-rating .review-count {
        color: #666;
        margin-top: 0.5rem;
    }

    .rating-bars {
        padding: 1rem 0;
    }

    .rating-bar-row {
        display: flex;
        align-items: center;
        gap: 1rem;
        margin-bottom: 0.75rem;
    }

    .stars-label {
        min-width: 60px;
        font-size: 0.9rem;
    }

    .progress {
        flex: 1;
        height: 12px;
        background-color: #e9ecef;
    }

    .count-label {
        min-width: 40px;
        text-align: right;
        font-size: 0.9rem;
        color: #666;
    }

    .review-filter-dropdown {
        max-width: 200px;
        border: 2px solid #dee2e6;
        border-radius: 8px;
        padding: 0.75rem;
        cursor: pointer;
    }

    .review-card {
        background: white;
        border-radius: 12px;
        padding: 1.5rem;
        height: 100%;
        box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }

    .review-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 4px 20px rgba(0,0,0,0.15);
    }

    .review-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 1rem;
    }

    .stars {
        color: #ffc107;
        font-size: 1.2rem;
    }

    .review-date {
        color: #999;
        font-size: 0.85rem;
    }

    .reviewer-info {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        margin-bottom: 1rem;
    }

    .reviewer-icon {
        font-size: 2rem;
        color: #666;
    }

    .verified-badge {
        background: black;
        color: white;
        padding: 0.15rem 0.5rem;
        border-radius: 4px;
        font-size: 0.75rem;
        margin-left: 0.5rem;
    }

    .review-title {
        font-size: 1.1rem;
        font-weight: 600;
        margin: 1rem 0 0.5rem 0;
        color: #333;
    }

    .review-text {
        color: #666;
        line-height: 1.6;
        margin-bottom: 1rem;
    }

    .read-more-link {
        color: #007bff;
        text-decoration: underline;
        font-size: 0.9rem;
    }

    .read-more-link:hover {
        color: #0056b3;
    }

    .write-review-form {
        background: white;
        border-radius: 15px;
        padding: 2rem;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    }

    .review-form-card h3 {
        font-weight: 600;
        color: #333;
    }

    .form-label {
        font-weight: 600;
        color: #333;
        margin-bottom: 0.5rem;
    }

    .form-control {
        border: 2px solid #dee2e6;
        border-radius: 8px;
        padding: 0.75rem;
        font-size: 1rem;
    }

    .form-control:focus {
        border-color: #333;
        box-shadow: 0 0 0 0.2rem rgba(0,0,0,0.1);
    }

    .star-rating-list {
        display: flex;
        gap: 1rem;
        flex-direction: row;
    }

    .star-rating-list label {
        cursor: pointer;
        padding: 0.5rem 1rem;
        border: 2px solid #dee2e6;
        border-radius: 8px;
        transition: all 0.3s ease;
    }

    .star-rating-list input[type="radio"]:checked + label {
        background: #ffc107;
        border-color: #ffc107;
    }

    .form-buttons {
        display: flex;
        gap: 1rem;
        justify-content: flex-end;
        margin-top: 2rem;
    }

    .review-card-full {
        background: white;
        border-radius: 12px;
        padding: 2rem;
        box-shadow: 0 2px 10px rgba(0,0,0,0.08);
    }

    .review-header-full {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 1rem;
    }

    .stars-large {
        color: #ffc107;
        font-size: 1.5rem;
    }

    .reviewer-info-full {
        display: flex;
        align-items: center;
        gap: 1rem;
        margin: 1rem 0;
    }

    .reviewer-icon-large {
        font-size: 2.5rem;
        color: #666;
    }

    .review-title-full {
        font-size: 1.3rem;
        font-weight: 600;
        margin: 1rem 0;
        color: #333;
    }

    .review-text-full {
        color: #666;
        line-height: 1.8;
        font-size: 1.05rem;
    }

    @media (max-width: 768px) {
        .review-stats-container .row {
            text-align: center !important;
        }

        .rating-bars {
            margin-top: 2rem;
        }

        .form-buttons {
            flex-direction: column;
        }

        .form-buttons .btn {
            width: 100%;
        }
    }
</style>
    </main>

</asp:Content>
