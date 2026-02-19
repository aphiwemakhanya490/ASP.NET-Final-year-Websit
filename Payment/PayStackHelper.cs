using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using Newtonsoft.Json;

namespace M4Website.Payment
{
    public class PayStackHelper
    {
        // Test Keys (replace with live keys when going production)
        public const string PUBLIC_KEY = "sk_test_b45f93a046bbc26980d1d4417d55a95b10e779e7";
        public const string SECRET_KEY = "sk_test_b45f93a046bbc26980d1d4417d55a95b10e779e7";

        // Live Keys (use when going live)
        // public const string PUBLIC_KEY = "pk_live_YOUR_LIVE_KEY";
        // public const string SECRET_KEY = "sk_live_YOUR_LIVE_KEY";

        public const string BASE_URL = "https://api.paystack.co";

        public static string GenerateReference()
        {
            return $"KWM{DateTime.Now:yyyyMMddHHmmss}{new Random().Next(1000, 9999)}";
        }

        public static async Task<PayStackResponse> InitializeTransaction(
            string email,
            decimal amount,
            string reference,
            string callbackUrl)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Add("Authorization", $"Bearer {SECRET_KEY}");

                    var data = new
                    {
                        email = email,
                        amount = (amount * 100).ToString("F0"), // Convert to kobo (cents)
                        reference = reference,
                        callback_url = callbackUrl,
                        currency = "ZAR"
                    };

                    var json = JsonConvert.SerializeObject(data);
                    var content = new StringContent(json, Encoding.UTF8, "application/json");

                    var response = await client.PostAsync($"{BASE_URL}/transaction/initialize", content);
                    var responseString = await response.Content.ReadAsStringAsync();

                    return JsonConvert.DeserializeObject<PayStackResponse>(responseString);
                }
            }
            catch (Exception ex)
            {
                return new PayStackResponse
                {
                    status = false,
                    message = ex.Message
                };
            }
        }

        public static async Task<PayStackVerifyResponse> VerifyTransaction(string reference)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Add("Authorization", $"Bearer {SECRET_KEY}");

                    var response = await client.GetAsync($"{BASE_URL}/transaction/verify/{reference}");
                    var responseString = await response.Content.ReadAsStringAsync();

                    return JsonConvert.DeserializeObject<PayStackVerifyResponse>(responseString);
                }
            }
            catch (Exception ex)
            {
                return new PayStackVerifyResponse
                {
                    status = false,
                    message = ex.Message
                };
            }
        }
    }

    // Response models
    public class PayStackResponse
    {
        public bool status { get; set; }
        public string message { get; set; }
        public PayStackData data { get; set; }
    }

    public class PayStackData
    {
        public string authorization_url { get; set; }
        public string access_code { get; set; }
        public string reference { get; set; }
    }

    public class PayStackVerifyResponse
    {
        public bool status { get; set; }
        public string message { get; set; }
        public PayStackTransactionData data { get; set; }
    }

    public class PayStackTransactionData
    {
        public string status { get; set; }
        public string reference { get; set; }
        public decimal amount { get; set; }
        public string currency { get; set; }
        public string paid_at { get; set; }
    }
}