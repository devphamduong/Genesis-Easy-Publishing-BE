using System.Security.Cryptography;

namespace app.Service
{
    public class HashPassword
    {
        private const int SaltSize = 128 / 8;
        private const int KeySize = 256 / 8;
        private const int Iterations = 100000;
        private const char Delimiter = ';';
        public string Hash(string password)
        {
            byte[] salt = RandomNumberGenerator.GetBytes(SaltSize);
            byte[] hash = Rfc2898DeriveBytes.Pbkdf2(password, salt, Iterations, HashAlgorithmName.SHA256, KeySize);
            return string.Join(Delimiter, Convert.ToBase64String(salt), Convert.ToBase64String(hash));
        }

        public bool Verify(string passwordHash, string passwordInput)
        {
            string[] elements = passwordHash.Split(Delimiter);
            byte[] salt = Convert.FromBase64String(elements[0]);
            byte[] hash = Convert.FromBase64String(elements[1]);
            byte[] hashInput = Rfc2898DeriveBytes.Pbkdf2(passwordInput, salt, Iterations, HashAlgorithmName.SHA256, KeySize);
            return CryptographicOperations.FixedTimeEquals(hash, hashInput);
        }
    }
}
