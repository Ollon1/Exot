<?php
// db_access.php
class DatabaseAccess
{
    private $host = 'localhost'; // Database host
    private $db_name = 'exot_db'; // Database name
    private $username = 'root'; // Database username
    private $password = ''; // Database password
    private $conn;

    public function getConnection()
    {
        $this->conn = null;

        try {
            $dsn = "mysql:host=" . $this->host . ";dbname=" . $this->db_name;
            $this->conn = new PDO($dsn, $this->username, $this->password);
            $this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            // echo "Connection successfully established!";
        } catch (PDOException $e) {
            echo "Connection error: " . $e->getMessage();
        }

        return $this->conn;
    }
}
