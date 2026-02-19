<%@ Page Title="" Language="C#" MasterPageFile="~/Man.Master" AutoEventWireup="true" CodeBehind="Reports.aspx.cs" Inherits="M4Website.Manager.Reports" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .reports-container {
            padding: 20px;
            background-color: #f8f9fa;
            min-height: 100vh;
        }
        
        .reports-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        .reports-header h1 {
            margin: 0;
            font-size: 2.5rem;
            font-weight: 700;
        }
        
        .reports-header p {
            margin: 10px 0 0 0;
            opacity: 0.9;
            font-size: 1.1rem;
        }
        
        .powerbi-container {
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .powerbi-frame {
            width: 100%;
            height: 800px;
            border: none;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }
        
        .report-info {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.08);
            margin-bottom: 25px;
            border-left: 4px solid #28a745;
        }
        
        .report-info h3 {
            color: #2c3e50;
            margin-bottom: 15px;
            font-size: 1.4rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        
        .info-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
        }
        
        .info-item i {
            color: #667eea;
            font-size: 1.2rem;
        }
        
        .info-item .label {
            font-weight: 600;
            color: #495057;
            font-size: 0.9rem;
        }
        
        .info-item .value {
            color: #6c757d;
            font-size: 0.9rem;
        }
        
        .loading-indicator {
            text-align: center;
            padding: 40px;
            color: #6c757d;
        }
        
        .loading-indicator i {
            font-size: 2rem;
            margin-bottom: 15px;
            color: #667eea;
        }
        
        @media (max-width: 768px) {
            .powerbi-frame {
                height: 600px;
            }
            
            .reports-header h1 {
                font-size: 2rem;
            }
            
            .info-grid {
                grid-template-columns: 1fr;
            }
        }
        
        @media (max-width: 480px) {
            .powerbi-frame {
                height: 400px;
            }
            
            .reports-container {
                padding: 10px;
            }
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="reports-container">
        <!-- Header Section -->
        <div class="reports-header">
            <h1><i class="fas fa-chart-line"></i> Business Intelligence Dashboard</h1>
            <p>Real-time analytics and insights for KwaMshana Café</p>
        </div>
        
        <!-- Report Information -->
        <div class="report-info">
            <h3><i class="fas fa-info-circle"></i> Report Overview</h3>
            <p>This interactive dashboard provides comprehensive business intelligence including sales performance, customer analytics, subscription metrics, and operational insights.</p>
            
            <div class="info-grid">
                <div class="info-item">
                    <i class="fas fa-sync-alt"></i>
                    <div>
                        <div class="label">Data Refresh</div>
                        <div class="value">Real-time</div>
                    </div>
                </div>
                <div class="info-item">
                    <i class="fas fa-shield-alt"></i>
                    <div>
                        <div class="label">Security</div>
                        <div class="value">Secure Embed</div>
                    </div>
                </div>
                <div class="info-item">
                    <i class="fas fa-mobile-alt"></i>
                    <div>
                        <div class="label">Compatibility</div>
                        <div class="value">Responsive Design</div>
                    </div>
                </div>
                <div class="info-item">
                    <i class="fas fa-clock"></i>
                    <div>
                        <div class="label">Last Updated</div>
                        <div class="value"><%= DateTime.Now.ToString("MMM dd, yyyy") %></div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Power BI Report Container -->
        <div class="powerbi-container">
            <div id="reportLoading" class="loading-indicator">
                <i class="fas fa-spinner fa-spin"></i>
                <h4>Loading Power BI Report...</h4>
                <p>Please wait while we load your business intelligence dashboard</p>
            </div>
            
            <iframe id="powerbiFrame" class="powerbi-frame"
                src="https://app.powerbi.com/view?r=eyJrIjoiNThjZjk4N2UtZjEzZi00Yzk2LWI5MDEtNjI4MDMwNjE3NzA5IiwidCI6IjIyNjgyN2Q2LWE5ZDAtNDcwZC04YzE1LWIxNDZiMDE5MmQ1MSIsImMiOjh9"
                frameborder="0"
                allowfullscreen="true"
                onload="hideLoading()">
            </iframe>
        </div>
    </div>

    <script>
        function hideLoading() {
            document.getElementById('reportLoading').style.display = 'none';
        }

        // Show loading initially
        document.addEventListener('DOMContentLoaded', function () {
            document.getElementById('reportLoading').style.display = 'block';
        });

        // Handle iframe load errors
        document.getElementById('powerbiFrame').addEventListener('error', function () {
            document.getElementById('reportLoading').innerHTML = `
                <i class="fas fa-exclamation-triangle" style="color: #dc3545;"></i>
                <h4>Failed to Load Report</h4>
                <p>Please check your internet connection and try again.</p>
                <button onclick="location.reload()" class="btn-view-report" style="margin-top: 15px;">
                    <i class="fas fa-redo"></i> Retry Loading
                </button>
            `;
        });
    </script>
</asp:Content>