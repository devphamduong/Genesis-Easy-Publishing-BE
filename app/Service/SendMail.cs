using System.Net.Mail;
using System.Net;

namespace app.Service
{
    public class SendMail
    {
        private string Sender = "nam2998nam@gmail.com";
        private string Password = "gbjc ognq qjin qsqq";
        private int Port = 587;
        private string Host = "smtp.gmail.com";
        public void Send(string receiver, string subject, string content)
        {
            MailAddress to = new MailAddress(receiver);
            MailAddress from = new MailAddress(Sender);

            MailMessage email = new MailMessage(from, to);
            email.IsBodyHtml = true;
            email.Subject = subject;
            email.Body = content;

            SmtpClient smtp = new SmtpClient();
            smtp.Host = Host;
            smtp.Port = Port;
            smtp.Credentials = new NetworkCredential(Sender, Password);
            smtp.DeliveryMethod = SmtpDeliveryMethod.Network;
            smtp.EnableSsl = true;
            smtp.Send(email);
        }
    }
}
