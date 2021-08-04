<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
	<sql:setDataSource var = "snapshot" driver = "oracle.jdbc.driver.OracleDriver"
		url = "jdbc:oracle:thin:@localhost:1521:xe"
		user = "hr"  password = "1234"/>
	<sql:query dataSource="${snapshot}" var="result"
		sql="select 
				member_name, 
				email, 
				library_name, 
				borrow_restrict_limit, 
				loan_restrict_limit 
			from 
				members, 
				libraries 
			where 
				members.library_num = libraries.library_num and 
				member_num = ?">
		<sql:param value="${login_id}" />
	</sql:query>
	<head>
		<meta charset="UTF-8">
		<title>User page</title>
	</head>
	<body>
		<%@ include file="/includes/header.jsp"%>
		<main>
			<c:forEach var="row" items="${result.rows}">
				<h1>${login_name}님의 페이지입니다. <a href="../">back</a></h1>
				<table>
					<tbody>
						<tr>
							<td>번호</td>
							<td>${login_id}</td>
						</tr>
						<tr>
							<td>이메일</td>
							<td>${row.email}</td>
						</tr>
						<tr>
							<td>소속 도서관</td>
							<td>${row.library_name}</td>
						</tr>
						<tr>
							<td>대출 제한 기한</td>
							<td>
								<c:choose>
									<c:when test="${not empty row.borrow_restrict_limit}">
										<fmt:formatDate type="date" value="${row.borrow_restrict_limit}"/>
									</c:when>
									<c:otherwise>정상</c:otherwise>
								</c:choose>
							</td>
						</tr>
						<tr>
							<td>상호대차 제한 기한</td>
							<td>
								<c:choose>
									<c:when test="${not empty row.loan_restrict_limit}">
										<fmt:formatDate type="date" value="${row.loan_restrict_limit}"/>
									</c:when>
									<c:otherwise>정상</c:otherwise>
								</c:choose>
							</td>
						</tr>
						<tr>
							<td>주문번호</td>
							<td>${login_order_num}</td>
						</tr>
					</tbody>
				</table>
				<ul>
					<li><a href="./borrow">대출 기록</a></li>
					<li><a href="./reserve">예약 기록</a></li>
					<li><a href="./loan">상호대차 기록</a></li>
				</ul>
			</c:forEach>
			<c:if test="${result.rowCount eq 0}">
				<p>먼저 로그인해주세요</p>
			</c:if>
		</main>
	</body>
</html>