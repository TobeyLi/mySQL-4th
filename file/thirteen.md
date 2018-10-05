	插入数据（INSERT）
当你建立了一个表之后，这是个空表，里面什么都没有，你怎么往这个表里面插入数据呢？
	那么我们就需要开始学习另外一个非常重要的关键字：INSERT,插入操作
INSERT 插入操作主要可以分为三大类
	1)插入完整的行
	2)插入行的一部分
	3)将查询的结果插入到表中

1.插入完整的行
	首先我们显示一下表Customers的结构：
	DESC Customers;
		+--------------+-----------+------+-----+---------+-------+
		| Field        | Type      | Null | Key | Default | Extra |
		+--------------+-----------+------+-----+---------+-------+
		| cust_id      | char(10)  | NO   | PRI | NULL    |       |
		| cust_name    | char(50)  | NO   |     | NULL    |       |
		| cust_address | char(50)  | YES  |     | NULL    |       |
		| cust_city    | char(50)  | YES  |     | NULL    |       |
		| cust_state   | char(5)   | YES  |     | NULL    |       |
		| cust_zip     | char(10)  | YES  |     | NULL    |       |
		| cust_country | char(50)  | YES  |     | NULL    |       |
		| cust_contact | char(50)  | YES  |     | NULL    |       |
		| cust_email   | char(255) | YES  |     | NULL    |       |
		+--------------+-----------+------+-----+---------+-------+
	可以看到，Customers 表中有cust_id,cust_name....等等列，需要插入的时候那么就需要插入这些值。
	eg.	INSERT INTO Customers VALUES('1000000006','Toy Land','123 Any street','New York','NY','11111','USA',NULL,NULL);
	执行了查看表的语句之后：
	+------------+---------------+----------------------+-----------+------------+----------+--------------+--------------------+-----------------------+
	| cust_id    | cust_name     | cust_address         | cust_city | cust_state | cust_zip | cust_country | cust_contact       | cust_email            |
	+------------+---------------+----------------------+-----------+------------+----------+--------------+--------------------+-----------------------+
	| 1000000001 | Village Toys  | 200 Maple Lane       | Detroit   | MI         | 44444    | USA          | John Smith         | sales@villagetoys.com |
	| 1000000002 | Kids Place    | 333 South Lake Drive | Columbus  | OH         | 43333    | USA          | Michelle Green     | NULL                  |
	| 1000000003 | Fun4All       | 1 Sunny Place        | Muncie    | IN         | 42222    | USA          | Jim Jones          | jjones@fun4all.com    |
	| 1000000004 | Fun4All       | 829 Riverside Drive  | Phoenix   | AZ         | 88888    | USA          | Denise L. Stephens | dstephens@fun4all.com |
	| 1000000005 | The Toy Store | 4545 53rd Street     | Chicago   | IL         | 54545    | USA          | Kim Howard         | NULL                  |
	| 1000000006 | Toy Land      | 123 Any street       | New York  | NY         | 11111    | USA          | NULL               | NULL                  |
	+------------+---------------+----------------------+-----------+------------+----------+--------------+--------------------+-----------------------+
	可以看到结果中，我们插入的行已经按照要求插入到表中。

	但是，这种的插入方式并不具备可移植性，因为一旦表的结构发生了，如cust_name列和cust_id列交换了位置，那么这一条插入就不具备有代表性。
	那么，可以存在另外一种插入方式：在表名之后指定列名
	eg.INSERT INTO Customers(cust_id,cust_name,cust_address,cust_city,cust_state,cust_zip,cust_country,cust_contact,cust_email) 
	VALUES('1000000006','Toy Land','123 Any street','New York','NY','11111','USA',NULL,NULL);
	
	因为提供了列名，所以VALUES必须以其指定的次序匹配指定的列名，不一定是按各列出现在表中的实际次序。
	其优点是，即使表的结构发生了改变，这条INSERT 语句照样能够正常工作。

2.插入部分的行
	通过分析Customers 表的结构可知，它的列的有一些值允许为NULL,且存在default，那么可以缺省插入：
	eg.	INSERT INTO Customers(cust_id,cust_name,cust_address,cust_city,cust_state,cust_zip,cust_country) 
	VALUES('1000000006','Toy Land','123 Any street','New York','NY','11111','USA');
	
	通过查询之后，照样能够得到与上面的查询的相同的结果。只不过，我们在插入的时候，因为cust_contact 和 cust_email 为NULL，这里直接省略
	
	省略列必须需要满足两种规则：
		1)该列定义为允许NULL值（无值或者空值）
		2)在表定义中给出默认值，这表示如果不给出值，那么该列将使用默认值。

3.插入检索出的数据。
	INSERT 一般用来给表插入指定列值的行。INSERT 还存在另外一种形式，可以利用它将SELECT 语句的结果插入表中。
	eg.	INSERT INTO Customers(cust_id,cust_name,cust_address,cust_city,cust_state,cust_zip,cust_country) 
	SELECT cust_id,cust_name,cust_address,cust_city,cust_state,cust_zip,cust_country FROM CustNew;
	
	这句话的意思是：从一个名为CustNew的表中读出数据，并且插入到Customers中去。
	注意：为了简单起见，这里的INSERT 和SELECT 语句中使用了相同的列名，但是，不一定需要列名匹配。这里DBMS不关心SELECT返回的列名，它使用的是列的位置。
	因此：SELECT中的第一列（不管其列名）将用来填充表列中的第一列，第二列将用来填充表列中的指定的第二列，依次类推。

4.从一个表复制到另外一个表。
	一般来说，直接在原表中进行操作是不安全，也是不提倡的，那么一般就是先把原表复制一份，然后去操作这份复制出来的新表，
	当结果没有问题的时候，才去操作新表。
		其中MySQL中的语句时：CREATE TABLE CustCopy AS SELECT * FROM Customers;
	
	SQL中的语法为：SELECT * INTO CustCopy FROM Customers;
	
	这两个句子的含义完全相同，只是DBMS所支持的语法不同。
	