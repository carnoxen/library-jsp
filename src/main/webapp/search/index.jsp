<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%-- 쿼리를 이용해 검색된 도서 출력 --%>
<!DOCTYPE html>
<html>
	<sql:setDataSource var = "snapshot" driver = "oracle.jdbc.driver.OracleDriver"
		url = "jdbc:oracle:thin:@localhost:1521:xe"
		user = "hr"  password = "1234"/>
	<sql:query dataSource="${snapshot}" var="booklists"
		sql="select 
				b.isbn isbn, 
				b.book_name book_name 
			from 
				books b, 
				book_authors ba, 
				authors a, 
				libraries l, 
				library_books lb 
			where 
				b.isbn = ba.isbn and 
				ba.author_num = a.author_num and 
				b.isbn = lb.isbn and 
				lb.library_num = l.library_num and 
				(${not empty param.query ? param.query : '1 = 1'}) 
			group by 
				b.isbn, 
				b.book_name">
	</sql:query>
	<head>
		<meta charset="UTF-8" />
		<title>Home page</title>
	</head>
	<body>
		<%@ include file="/includes/header.jsp" %>
		<main>
			<h1>검색 결과</h1>
			<ul>
				<c:forEach var="row" items="${booklists.rows}">
					<li><a href="../book?isbn=${row.isbn}">${row.book_name}</a></li>
				</c:forEach>
			</ul>
		</main>
	</body>
</html>