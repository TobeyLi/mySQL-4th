	使用函数处理数据
前提：在MySQL里面使用函数的时候，一定要做好注释。

大多数的函数支持以下类型的函数
	1）用于处理文本字符串（如删除或者填充值，转换值为大写或者小写）的文本函数；
	2）用于在数值数据上进行算术操作（如返回绝对值，进行代数运算）的数值函数；
	3）用于处理日期和时间值并从这些值中提取特定成分（如返回两个日期之差，检查日期的有效性）的日期和时间函数；
	4）返回DBMS正使用的特殊信息（如返回用户的登陆信息）的系统函数

1.文本处理函数
	a)RTrim()函数。---->作用：去掉串尾的空格来整理数据(即是去掉字符串右边的空格)。  LTrim（）函数与之相反，是删除字符串左边的空格
	eg.	 SELECT Concat(RTrim(vend_name),'(',RTrim(vend_country),')') AS vend_title FROM Vendors ORDER BY vend_name;
		+------------------------+
		| vend_title             |
		+------------------------+
		| Bear Emporium(USA)     |
		| Bears R Us(USA)        |
		| Doll House Inc.(USA)   |
		| Fun and Games(England) |
		| Furball Inc.(USA)      |
		| Jouets et ours(France) |
		+------------------------+
	b）Upper()函数。作用：将文本转换为大写并返回，与之相反的是Lower（）函数，将文本转换为小写
	eg.	SELECT vend_name,Upper(vend_name) AS Vender_UPPER FROM Vendors ORDER BY vend_name;
		+-----------------+-----------------+
		| vend_name       | Vender_UPPER    |
		+-----------------+-----------------+
		| Bear Emporium   | BEAR EMPORIUM   |
		| Bears R Us      | BEARS R US      |
		| Doll House Inc. | DOLL HOUSE INC. |
		| Fun and Games   | FUN AND GAMES   |
		| Furball Inc.    | FURBALL INC.    |
		| Jouets et ours  | JOUETS ET OURS  |
		+-----------------+-----------------+
	eg.	SELECT vend_name,Lower(vend_name) AS Vender_Lower FROM Vendors ORDER BY vend_name;
		+-----------------+-----------------+
		| vend_name       | Vender_Lower    |
		+-----------------+-----------------+
		| Bear Emporium   | bear emporium   |
		| Bears R Us      | bears r us      |
		| Doll House Inc. | doll house inc. |
		| Fun and Games   | fun and games   |
		| Furball Inc.    | furball inc.    |
		| Jouets et ours  | jouets et ours  |
		+-----------------+-----------------+
	c） Length(str)函数。作用：返回串的长度
	eg.	SELECT vend_name,Length(vend_name) AS Vender_Length FROM Vendors ORDER BY vend_name;
		+-----------------+---------------+
		| vend_name       | Vender_Length |
		+-----------------+---------------+
		| Bear Emporium   |            13 |
		| Bears R Us      |            10 |
		| Doll House Inc. |            15 |
		| Fun and Games   |            13 |
		| Furball Inc.    |            12 |
		| Jouets et ours  |            14 |
		+-----------------+---------------+
	d） Locate(substr,str)函数。
		参数：substr待查找的子串，str待查找的串。
		作用：返回子串 substr 在字符串 str 中第一次出现的位置。如果子串 substr 在 str 中不存在，返回值为 0。
		eg.	SELECT vend_name,Locate('o',vend_name) AS Vender_name_Locate FROM Vendors ORDER BY vend_name;
			+-----------------+--------------------+
			| vend_name       | Vender_name_Locate |
			+-----------------+--------------------+
			| Bear Emporium   |                  9 |
			| Bears R Us      |                  0 |
			| Doll House Inc. |                  2 |
			| Fun and Games   |                  0 |
			| Furball Inc.    |                  0 |
			| Jouets et ours  |                  2 |
			+-----------------+--------------------+
		另一种情况：Locate(substr,str，pos)。作用：返回子串 substr 在字符串 str 中的第 pos 位置后第一次出现的位置。如果 substr 不在 str 中返回 0。
	e) Position(substr IN str)函数。
		作用：返回substr在str中第一次出现的位置
		eg.	SELECT vend_name,Position('o' IN vend_name) AS Vender_name_Locate FROM Vendors ORDER BY vend_name;
			+-----------------+--------------------+
			| vend_name       | Vender_name_Locate |
			+-----------------+--------------------+
			| Bear Emporium   |                  9 |
			| Bears R Us      |                  0 |
			| Doll House Inc. |                  2 |
			| Fun and Games   |                  0 |
			| Furball Inc.    |                  0 |
			| Jouets et ours  |                  2 |
			+-----------------+--------------------+
		可以看到：Position函数和带两个参数的Locate函数作用是一样的。
	f）SubString(str,pos)函数。
		作用：返回从第pos位置出现的子串的字符
		eg.SELECT vend_name,SubString(vend_name,2) AS Vender_name_Locate FROM Vendors ORDER BY vend_name;
			+-----------------+--------------------+
			| vend_name       | Vender_name_Locate |
			+-----------------+--------------------+
			| Bear Emporium   | ear Emporium       |
			| Bears R Us      | ears R Us          |
			| Doll House Inc. | oll House Inc.     |
			| Fun and Games   | un and Games       |
			| Furball Inc.    | urball Inc.        |
			| Jouets et ours  | ouets et ours      |
			+-----------------+--------------------+
		同时，substring(str, pos, len)也存在。作用：返回从pos位置开始长度为len的子串的字符
		eg.	SELECT vend_name,SubString(vend_name,2,4) AS Vender_name_Locate FROM Vendors ORDER BY vend_name;
			+-----------------+--------------------+
			| vend_name       | Vender_name_Locate |
			+-----------------+--------------------+
			| Bear Emporium   | ear                |
			| Bears R Us      | ears               |
			| Doll House Inc. | oll                |
			| Fun and Games   | un a               |
			| Furball Inc.    | urba               |
			| Jouets et ours  | ouet               |
			+-----------------+--------------------+
	g）SOUNDEX()函数
		SOUNDEX()函数是一个将任何文本串转换为描述语音表示的字母模式的算法。它考虑了类似于发音字符和字节，能够对文本发音进行比较而不是字母比较。
	eg：如果库中存在一名名为Michael Green的客户而搜索的时候的输入错误，下面的sql是不会有任何返回结果的。
	SELECT cust_name,cust_contact FROM Customers WHERE cust_contact = 'Michael Green';
		Empty set (0.00 sec)
	而如果这样写：
	SELECT cust_name,cust_contact FROM Customers WHERE 	SOUNDEX(cust_contact) = SOUNDEX('Michael Green');
		+------------+----------------+
		| cust_name  | cust_contact   |
		+------------+----------------+
		| Kids Place | Michelle Green |
		+------------+----------------+
	因为两者发音相似，所以他们的SOUNDEX值匹配，这样就会返回一条数据。

2.时间和日期处理函数
	使用的比较少，需要的时候自己自行Google解决。

3.数值处理函数
	下面是常用的数值处理函数
	ABS()      ---返回一个数的绝对值
	COS()      ---返回一个角度的余弦
	EXP()      ---返回一个数的指数值
	PI()      ---返回圆周率
	SIN()      ---返回一个角度的正弦
	SQRT()      ---返回一个数的平方根
	TAN()      ---返回一个角度的正切
	 eg. SELECT ABS(-30) AS abs;
		+-----+
		| abs |
		+-----+
		|  30 |
		+-----+