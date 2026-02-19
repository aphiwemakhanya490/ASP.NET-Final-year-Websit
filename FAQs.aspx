<%@ Page Title="FAQs" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="FAQs.aspx.cs" Inherits="M4Website.FAQs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .faq-container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        .faq-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 60px 30px;
            border-radius: 15px;
            text-align: center;
            margin-bottom: 40px;
        }

        .faq-header h1 {
            font-size: 3rem;
            font-weight: 700;
            margin-bottom: 15px;
        }

        .faq-header p {
            font-size: 1.2rem;
            opacity: 0.95;
        }

        .faq-categories {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        .category-card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            cursor: pointer;
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }

        .category-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
            border-color: #667eea;
        }

        .category-icon {
            font-size: 3rem;
            color: #667eea;
            margin-bottom: 15px;
        }

        .category-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: #2c3e50;
        }

        .faq-section {
            background: white;
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.08);
        }

        .faq-section-title {
            font-size: 1.8rem;
            color: #2c3e50;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 3px solid #667eea;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .faq-item {
            margin-bottom: 20px;
            border-bottom: 1px solid #e9ecef;
            padding-bottom: 20px;
        }

        .faq-item:last-child {
            border-bottom: none;
        }

        .faq-question {
            font-size: 1.15rem;
            font-weight: 600;
            color: #2c3e50;
            cursor: pointer;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: all 0.3s ease;
        }

        .faq-question:hover {
            background: #e9ecef;
        }

        .faq-question i {
            color: #667eea;
            transition: transform 0.3s ease;
        }

        .faq-question.active i {
            transform: rotate(180deg);
        }

        .faq-answer {
            padding: 20px 15px;
            color: #666;
            line-height: 1.8;
            display: none;
            animation: slideDown 0.3s ease;
        }

        .faq-answer.show {
            display: block;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .contact-cta {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px;
            border-radius: 12px;
            text-align: center;
            margin-top: 40px;
        }

        .contact-cta h3 {
            font-size: 2rem;
            margin-bottom: 15px;
        }

        .contact-cta p {
            font-size: 1.1rem;
            margin-bottom: 25px;
            opacity: 0.95;
        }

        .btn-contact {
            background: white;
            color: #667eea;
            padding: 15px 40px;
            border-radius: 8px;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
        }

        .btn-contact:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            color: #667eea;
            text-decoration: none;
        }

        @media (max-width: 768px) {
            .faq-header h1 {
                font-size: 2rem;
            }

            .faq-categories {
                grid-template-columns: 1fr;
            }
        }
    </style>

    <div class="faq-container">
        <!-- Header -->
        <div class="faq-header">
            <h1><i class="fas fa-question-circle"></i> Frequently Asked Questions</h1>
            <p>Find answers to common questions about our services</p>
        </div>

        <!-- Category Cards -->
        <div class="faq-categories">
            <div class="category-card" onclick="scrollToSection('general')">
                <div class="category-icon"><i class="fas fa-info-circle"></i></div>
                <div class="category-title">General</div>
            </div>
            <div class="category-card" onclick="scrollToSection('subscriptions')">
                <div class="category-icon"><i class="fas fa-calendar-check"></i></div>
                <div class="category-title">Subscriptions</div>
            </div>
            <div class="category-card" onclick="scrollToSection('orders')">
                <div class="category-icon"><i class="fas fa-shopping-cart"></i></div>
                <div class="category-title">Orders</div>
            </div>
            <div class="category-card" onclick="scrollToSection('payment')">
                <div class="category-icon"><i class="fas fa-credit-card"></i></div>
                <div class="category-title">Payment</div>
            </div>
        </div>

        <!-- General FAQs -->
        <div class="faq-section" id="general">
            <h2 class="faq-section-title">
                <i class="fas fa-info-circle"></i>
                General Questions
            </h2>

            <div class="faq-item">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    What are KwaMshana Café's operating hours?
                    <i class="fas fa-chevron-down"></i>
                </div>
                <div class="faq-answer">
                    We are open Monday to Friday from 7:30 AM to 5:00 PM. We're closed on weekends and public holidays.
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    Where is KwaMshana Café located?
                    <i class="fas fa-chevron-down"></i>
                </div>
                <div class="faq-answer">
                    We're located at 277 Rick Turner Road, Gate 7, UKZN Howard College, Durban. You can find us easily on campus!
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    Do you cater for dietary restrictions?
                    <i class="fas fa-chevron-down"></i>
                </div>
                <div class="faq-answer">
                    Yes! We accommodate various dietary requirements including vegetarian, vegan, halal, and specific allergies. Just let us know when placing your order or subscription.
                </div>
            </div>
        </div>

        <!-- Subscription FAQs -->
        <div class="faq-section" id="subscriptions">
            <h2 class="faq-section-title">
                <i class="fas fa-calendar-check"></i>
                Meal Subscriptions
            </h2>

            <div class="faq-item">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    What's the difference between Worker and Student subscriptions?
                    <i class="fas fa-chevron-down"></i>
                </div>
                <div class="faq-answer">
                    Worker subscriptions cost R1,200/month while Student subscriptions cost R1,000/month. Both include daily meals Monday to Friday. The pricing difference helps make our meals more accessible to students.
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    Can I cancel my subscription?
                    <i class="fas fa-chevron-down"></i>
                </div>
                <div class="faq-answer">
                    Unfortunately, subscriptions cannot be cancelled once payment is made. This policy helps us plan our food preparation and avoid waste. Please carefully consider your commitment before subscribing.
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    What if I miss a meal day?
                    <i class="fas fa-chevron-down"></i>
                </div>
                <div class="faq-answer">
                    Missed meals cannot be refunded or carried forward. However, you can arrange for someone else to collect your meal on your behalf - just notify us in advance.
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    How does delivery work for subscriptions?
                    <i class="fas fa-chevron-down"></i>
                </div>
                <div class="faq-answer">
                    Delivery costs an additional R250/month. Meals are delivered to your specified address between 12:00 PM and 2:00 PM. Pick-up is free and available at our location during operating hours.
                </div>
            </div>
        </div>

        <!-- Orders FAQs -->
        <div class="faq-section" id="orders">
            <h2 class="faq-section-title">
                <i class="fas fa-shopping-cart"></i>
                Daily Orders
            </h2>

            <div class="faq-item">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    Can I place an order for same-day delivery?
                    <i class="fas fa-chevron-down"></i>
                </div>
                <div class="faq-answer">
                    Yes! Orders placed before 11:00 AM can be delivered the same day. Orders after 11:00 AM will be delivered the next business day.
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    What's the minimum order for delivery?
                    <i class="fas fa-chevron-down"></i>
                </div>
                <div class="faq-answer">
                    There's no minimum order value! We'll deliver any order, though delivery fees may apply based on your location.
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    How can I track my order?
                    <i class="fas fa-chevron-down"></i>
                </div>
                <div class="faq-answer">
                    You can track your order status by logging into your account and visiting the "Track Order" page. You'll receive updates via email as your order progresses.
                </div>
            </div>
        </div>

        <!-- Payment FAQs -->
        <div class="faq-section" id="payment">
            <h2 class="faq-section-title">
                <i class="fas fa-credit-card"></i>
                Payment & Billing
            </h2>

            <div class="faq-item">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    What payment methods do you accept?
                    <i class="fas fa-chevron-down"></i>
                </div>
                <div class="faq-answer">
                    We accept all major credit and debit cards through our secure PayStack payment gateway. We also accept EFT and instant EFT payments.
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    Is my payment information secure?
                    <i class="fas fa-chevron-down"></i>
                </div>
                <div class="faq-answer">
                    Absolutely! All payments are processed through PayStack, a PCI-DSS compliant payment processor. We never store your card details on our servers.
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    Do you offer refunds?
                    <i class="fas fa-chevron-down"></i>
                </div>
                <div class="faq-answer">
                    Refunds are considered on a case-by-case basis for daily orders if there's an issue with your meal. Subscription refunds are not available as stated in our terms and conditions.
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    Will I receive a receipt?
                    <i class="fas fa-chevron-down"></i>
                </div>
                <div class="faq-answer">
                    Yes! A receipt is automatically emailed to you after every successful payment. You can also download receipts from your account dashboard.
                </div>
            </div>
        </div>

        <!-- Contact CTA -->
        <div class="contact-cta">
            <h3>Still have questions?</h3>
            <p>Our team is here to help! Reach out and we'll get back to you as soon as possible.</p>
            <a href="Contact.aspx" class="btn-contact">
                <i class="fas fa-envelope"></i> Contact Us
            </a>
        </div>
    </div>

    <script>
        function toggleAnswer(element) {
            const answer = element.nextElementSibling;
            const allQuestions = document.querySelectorAll('.faq-question');
            const allAnswers = document.querySelectorAll('.faq-answer');

            // Close all other answers
            allQuestions.forEach(q => {
                if (q !== element) {
                    q.classList.remove('active');
                }
            });

            allAnswers.forEach(a => {
                if (a !== answer) {
                    a.classList.remove('show');
                }
            });

            // Toggle current answer
            element.classList.toggle('active');
            answer.classList.toggle('show');
        }

        function scrollToSection(sectionId) {
            const section = document.getElementById(sectionId);
            section.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
    </script>
</asp:Content>