<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%-- 메인 페이지. 책 검색 --%>
<!DOCTYPE html>
<html>
	<sql:setDataSource var="snapshot" driver="oracle.jdbc.driver.OracleDriver"
		url="jdbc:oracle:thin:@localhost:1521:xe"
		user="hr"  password="1234"/>
	<sql:query var="result" dataSource="${snapshot}" sql="select * from libraries" />
	<head>
		<meta charset="UTF-8" />
		<title>Home page</title>
	</head>
	<body>
		<%@ include file="/includes/header.jsp" %>
		<main>
			<h1>상호대차</h1>
			<form method="get" action="/library/tasks/loan.jsp">
				<p>
					<input type="text" name="register_num" value="${param.register_num}" readonly="readonly" />
					<select name="library_num">
						<c:forEach var="row" items="${result.rows}">
							<option value="${row.library_num}">${row.library_name}</option>
						</c:forEach>
					</select>
					<input type="submit" value="search" />
				</p>
			</form>
		</main>
	</body>
</html>