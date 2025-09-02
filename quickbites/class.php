<?php

class Database
{

    private $db_host = "localhost";
    private $db_user = "root";
    private $db_pass = "";
    private $db_name = "quickbites";

    private $mysql = "";
    private $con = false;
    private $result = array();


    public function __construct()
    {
        
        if (!$this->con) {
            $this->mysql = new mysqli($this->db_host, $this->db_user, $this->db_pass, $this->db_name);
            if ($this->mysql->connect_error) {
                array_push($this->result, $this->mysql->connect_error);
            } else {
                $this->con = true;
            }
        }
    }

    public function insert($table, $para = array())
    {
        if ($this->con) {

            $tab_col = implode(', ', array_keys($para));
            $tab_val = implode("', '", $para);
            $sql = "INSERT INTO $table($tab_col) VALUES ('$tab_val')";
            $qry = $this->mysql->query($sql);

            if ($qry) {
                array_push($this->result, "Data inserted");
                return true;
            } else {
                array_push($this->result, $this->mysql->error);
                return false;
            }
        } else {
            return false;
        }

    }

  public function update($table, $condition, $para = array())
{
    if ($this->con) {
        $arg = array();
        foreach ($para as $key => $value) {
            $arg[] = "$key = '$value'";
        }

        $tab = implode(', ', $arg);
        $sql = "UPDATE $table SET $tab WHERE $condition";
        $qry = $this->mysql->query($sql);

        if ($qry) {
            array_push($this->result, "Data Update");
            return true;
        } else {
            array_push($this->result, $this->mysql->error);
            return false;
        }
    } else {
        return false;
    }
}
// $obj->update("user", ["name" => "Khushal"], "id = 5");
// $obj->update("user", "id = 5", ["name" => "Khushal"]);


    public function delete($table, $condition)
    {

        if ($this->con) {

            $sql = "DELETE FROM $table WHERE $condition";

            if ($this->mysql->query($sql)) {
                array_push($this->result, "Data delete");
                return true;
            } else {
                array_push($this->result, $this->mysql->error);
                return false;
            }
        } else {
            return false;
        }

    }


    public function select($table, $columns = "*", $condition = "")
    {
        if ($this->con) {
            $sql = "SELECT $columns FROM $table";
            if (!empty($condition)) {
                $sql .= " WHERE $condition";
            }

            $qry = $this->mysql->query($sql);
            if ($qry) {
                $this->result = $qry->fetch_all(MYSQLI_ASSOC);
                return true;
            } else {
                array_push($this->result, $this->mysql->error);
                return false;
            }
        } else {
            return false;
        }
    }

    // public function selectall($table)
    // {

    //     if ($this->con) {

    //         $sql = "SELECT *FROM $table";
    //         $qry = $this->mysql->query($sql);

    //         if ($qry) {
    //             $this->result = $qry->fetch_all(MYSQLI_ASSOC);
    //             return true;
    //         } else {
    //             array_push($this->result, $this->mysql->error);
    //             return false;
    //         }
    //     } else {
    //         return false;
    //     }

    // }

    // public function select($table, $condition)
    // {

    //     if ($this->con) {

    //          $sql = "SELECT *FROM $table WHERE $condition";
    //          $qry = $this->mysql->query($sql);
    //          if ($qry) {
    //              $this->result = $qry->fetch_all(MYSQLI_ASSOC);
    //              return true;
    //         } else {
    //             array_push($this->result, $this->mysql->error);
    //             return false;
    //         }
    //     } else {
    //         return false;
    //     }

    // }
    public function getresult()
    {
        $val = $this->result;
        $this->result = array();
        return $val;
    }

    public function __destruct()
    {
        if ($this->con) {

            if ($this->mysql->close()) {
                $this->con = false;
                // return false;
            }
        }
    }

}

