
## LOB
[jdbc access](http://jdbc.postgresql.org/documentation/80/binary-data.html)
```sql
CREATE TABLE imageslo (imgname text, imgoid oid);
```

store blob
```java
// All LargeObject API calls must be within a transaction block
conn.setAutoCommit(false);

// Get the Large Object Manager to perform operations with
LargeObjectManager lobj = ((org.postgresql.PGConnection)conn).getLargeObjectAPI();

// Create a new large object
int oid = lobj.create(LargeObjectManager.READ | LargeObjectManager.WRITE);

// Open the large object for writing
LargeObject obj = lobj.open(oid, LargeObjectManager.WRITE);

// Now open the file
File file = new File("myimage.gif");
FileInputStream fis = new FileInputStream(file);

// Copy the data from the file to the large object
byte buf[] = new byte[2048];
int s, tl = 0;
while ((s = fis.read(buf, 0, 2048)) > 0) {
    obj.write(buf, 0, s);
    tl += s;
}

// Close the large object
obj.close();

// Now insert the row into imageslo
PreparedStatement ps = conn.prepareStatement("INSERT INTO imageslo VALUES (?, ?)");
ps.setString(1, file.getName());
ps.setInt(2, oid);
ps.executeUpdate();
ps.close();
fis.close();

// Finally, commit the transaction.
conn.commit();
```

retrive BLOB
```java
// All LargeObject API calls must be within a transaction block
conn.setAutoCommit(false);

// Get the Large Object Manager to perform operations with
LargeObjectManager lobj = ((org.postgresql.PGConnection)conn).getLargeObjectAPI();

PreparedStatement ps = conn.prepareStatement("SELECT imgoid FROM imageslo WHERE imgname = ?");
ps.setString(1, "myimage.gif");
ResultSet rs = ps.executeQuery();
while (rs.next()) {
    // Open the large object for reading
    int oid = rs.getInt(1);
    LargeObject obj = lobj.open(oid, LargeObjectManager.READ);

    // Read the data
    byte buf[] = new byte[obj.size()];
    obj.read(buf, 0, obj.size());
    // Do something with the data read here

    // Close the object
    obj.close();
}
rs.close();
ps.close();

// Finally, commit the transaction.
conn.commit();
```
