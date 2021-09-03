//oblig 5

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import java.util.LinkedList;
import java.util.List;
import java.util.Scanner;

public class Administrator {

    public static void main(String[] agrs) {

        String dbname = "waleedn"; // Input your UiO-username
        String user = "waleedn_priv"; // Input your UiO-username + _priv
        String pwd = "shahShiew9"; // Input the password for the _priv-user you got in a mail
        // Connection details
        String connectionStr =
            "user=" + user + "&" +
            "port=5432&" +
            "password=" + pwd + "";

        String host = "jdbc:postgresql://dbpg-ifi-kurs01.uio.no";
        String connectionURL =
            host + "/" + dbname +
            "?sslmode=require&ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory&" +
            connectionStr;

        try {
            // Load driver for PostgreSQL
            Class.forName("org.postgresql.Driver");
            // Create a connection to the database
            Connection connection = DriverManager.getConnection(connectionURL);

            int ch = 0;
            while (ch != 3) {
                System.out.println("-- ADMINISTRATOR --");
                System.out.println("Please choose an option:\n 1. Create bills\n 2. Insert new product\n 3. Exit");
                ch = getIntFromUser("Option: ", true);

                if (ch == 1) {
                    makeBills(connection);
                } else if (ch == 2) {
                    insertProduct(connection);
                }
            }
        } catch (SQLException|ClassNotFoundException ex) {
            System.err.println("Error encountered: " + ex.getMessage());
        }
    }

    private static void makeBills(Connection connection)  throws SQLException {
        // TODO: Oppg 2

        String username = getStrFromUser("Username: ");

        String valg1 = "SELECT ws.users.name AS n, ws.users.address as ad, SUM(ws.products.price * ws.orders.num) as total FROM ws.users INNER JOIN ws.orders USING(uid) INNER JOIN ws.products USING(pid) WHERE payed=0 GROUP BY n,ad;";
        String valg2 = "SELECT ws.users.name AS n, ws.users.address as ad, SUM(ws.products.price * ws.orders.num) as total FROM ws.users INNER JOIN ws.orders USING(uid) INNER JOIN ws.products USING(pid) WHERE payed=0 AND username = ? GROUP BY n,ad;";

        PreparedStatement s = connection.prepareStatement(valg1);

        if(username.isEmpty()){
            s=connection.prepareStatement(valg1);
        }
        else{
            s = connection.prepareStatement(valg2);
            s.setString(1 , username);
        }

        ResultSet r = s.executeQuery();

        try{
            while (r.next()) {
                System.out.print("\n-- Bill -- " );
                System.out.print("\nName: " + r.getString("n"));
                System.out.print("\nAddress: " + r.getString("ad"));
                System.out.println("\nTotal due: " +r.getDouble("total"));
            }
        }
        catch (SQLException e ) {
            System.out.println("SQLException error");
        }
    }


    private static void insertProduct(Connection connection) throws SQLException {
        // TODO: Oppg 3

        System.out.println("-- INSERT NEW PRODUCT --");
        String valg="INSERT INTO ws.products(name, price, cid, description) VALUES (?, ?, (SELECT cid FROM ws.categories WHERE name = ?), ?);";
        PreparedStatement s = connection.prepareStatement(valg);

        String productname= getStrFromUser("Product name: ");
        Double productprice= new Double(getStrFromUser("Price: "));
        String productcategory= getStrFromUser("Category type : ");
        String productdescription = getStrFromUser("Description: ");

        s.setString(1 ,productname);
        s.setDouble(2 ,productprice);
        s.setString(3 ,productcategory);
        s.setString(4 ,productdescription);
        s.executeUpdate();

        System.out.println("New product " + productname + " inserted.");
    }

    /**
     * Utility method that gets an int as input from user
     * Prints the argument message before getting input
     * If second argument is true, the user does not need to give input and can leave
     * the field blank (resulting in a null)
     */
    private static Integer getIntFromUser(String message, boolean canBeBlank) {
        while (true) {
            String str = getStrFromUser(message);
            if (str.equals("") && canBeBlank) {
                return null;
            }
            try {
                return Integer.valueOf(str);
            } catch (NumberFormatException ex) {
                System.out.println("Please provide an integer or leave blank.");
            }
        }
    }

    /**
     * Utility method that gets a String as input from user
     * Prints the argument message before getting input
     */
    private static String getStrFromUser(String message) {
        Scanner s = new Scanner(System.in);
        System.out.print(message);
        return s.nextLine();
    }
}
