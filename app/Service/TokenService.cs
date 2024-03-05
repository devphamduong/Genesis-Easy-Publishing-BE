using Azure.Core;
using System.IdentityModel.Tokens.Jwt;

namespace app.Service
{
    public class TokenService
    {

        //private JwtSecurityToken VerifyToken()
        //{
        //    var tokenCookie = Request.Cookies["access_token"];
        //    var tokenBearer = extractToken();
        //    var handler = new JwtSecurityTokenHandler();
        //    var jwtSecurityToken = handler.ReadJwtToken(!String.IsNullOrEmpty(tokenBearer) ? tokenBearer : tokenCookie);
        //    return jwtSecurityToken;
        //}

        //private string extractToken()
        //{
        //    if (!String.IsNullOrEmpty(Request.Headers.Authorization) &&
        //        Request.Headers.Authorization.ToString().Split(' ')[0] == "Bearer" &&
        //        !String.IsNullOrEmpty(Request.Headers.Authorization.ToString().Split(' ')[1]))
        //    {
        //        return Request.Headers.Authorization.ToString().Split(' ')[1];
        //    }
        //    return null;
        //}
    }
}
