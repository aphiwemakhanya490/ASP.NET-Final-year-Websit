<%@ Page Title="Payment Failed" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" 
    CodeBehind="PaymentFailed.aspx.cs" Inherits="M4Website.Payment.PaymentFailed"Async="true"%>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .failed-container {
            max-width: 600px;
            margin: 100px auto;
            padding: 40px;
            text-align: center;
        }

        .failed-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            padding: 50px 40px;
            animation: slideUp 0.5s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .failed-icon {
            width: 100px;
            height: 100px;
            background: linear-gradient(135deg, #dc3545, #c82333);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 30px;
            animation: scaleIn 0.5s ease-out 0.2s both;
        }

        @keyframes scaleIn {
            from {
                transform: scale(0);
            }
            to {
                transform: scale(1);
            }
        }

        .failed-icon i {
            font-size: 50px;
            color: white;
        }

        .failed-title {
            font-size: 2rem;
            color: #dc3545;
            margin-bottom: 15px;
            font-weight: 700;
        }

        .failed-message {
            font-size: 1.1rem;
            color: #495057;
            margin-bottom: 30px;
            line-height: 1.6;
        }

        .reason-box {
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            border-radius: 8px;
            padding: 15px;
            margin: 20px 0;
            text-align: left;
        }

        .reason-box i {
            color: #721c24;
            margin-right: 8px;
        }

        .reason-box p {
            margin: 5px 0;
            color: #721c24;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
            margin-top: 30px;
        }

        .btn-action {
            padding: 12px 30px;
            border-radius: 8px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s;
        }

        .btn-retry {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border: none;
        }

        .btn-retry:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
            color: white;
        }

        .btn-home {
            background: white;
            color: #667eea;
            border: 2px solid #667eea;
        }

        .btn-home:hover {
            background: #667eea;
            color: white;
        }

        .help-text {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #dee2e6;
            color: #6c757d;
            font-size: 0.95rem;
        }

        .help-text a {
            color: #667eea;
            text-decoration: none;
        }

        .help-text a:hover {
            text-decoration: underline;
        }
    </style>

    <div class="failed-container">
        <div class="failed-card">
            <div class="failed-icon">
                <i class="fas fa-times"></i>
            </div>

            <h1 class="failed-title">Payment Failed</h1>
            
            <p class="failed-message">
                We're sorry, but your payment could not be processed.
            </p>

            <div class="reason-box">
                <p><i class="fas fa-exclamation-triangle"></i> <strong>Possible reasons:</strong></p>
                <ul style="text-align: left; padding-left: 30px; margin: 10px 0;">
                    <li>Insufficient funds in your account</li>
                    <li>Payment was cancelled</li>
                    <li>Card details were incorrect</li>
                    <li>Network connection issue</li>
                    <li>Bank declined the transaction</li>
                </ul>
            </div>

            <div class="action-buttons">
                <a href="/Subscription.aspx" class="btn btn-action btn-retry">
                    <i class="fas fa-redo"></i> Try Again
                </a>
                <a href="/Default.aspx" class="btn btn-action btn-home">
                    <i class="fas fa-home"></i> Go to Home
                </a>
            </div>

            <div class="help-text">
                <p><i class="fas fa-life-ring"></i> Need help?</p>
                <p>
                    Contact our support team at 
                    <a href="aphiwemakhanya490@gmail.com">support@kwamshana.com</a>
                    or call us at <strong>065-551-0704</strong>
                </p>
            </div>
        </div>
    </div>
</asp:Content>