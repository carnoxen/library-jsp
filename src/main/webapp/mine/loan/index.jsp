<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
	<sql:setDataSource var = "snapshot" driver = "oracle.jdbc.driver.OracleDriver"
		url = "jdbc:oracle:thin:@localhost:1521:xe"
		user = "hr"  password = "1234"/>
	<sql:transaction dataSource="${snapshot}">
		<sql:query var="loans"
			sql="select 
					llb.loan_num loan_num, 
					llb.register_num register_num, 
					b.book_name book_name, 
					lr.library_name library_name, 
					llb.loan_status loan_status, 
					llb.store_date store_date, 
					case 
						when llb.store_date is null then 
							'waiting' 
						when llb.store_date + 3 >= trunc(sysdate) then 
							'valid' 
						else 
							'invalid' 
						end status 
				from 
					loan_library_books llb, 
					library_books lb, 
					books b, 
					libraries lr, 
					loans l 
				where 
					l.loan_num = llb.loan_num and 
					llb.register_num = lb.register_num and 
					lb.isbn = b.isbn and 
					llb.library_num = lr.library_num and 
					l.member_num = ?">
			<sql:param value="${login_id}" />
		</sql:query>
	</sql:transaction>
	<head>
		<meta charset="UTF-8">
		<title>User page</title>
	</head>
	<body>
		<%@ include file="/includes/header.jsp"%>
		<main>
			<h1>${login_name}님의 상호대차 기록 <a href="../">back</a></h1>
			<table>
				<thead>
					<tr>
						<th>등록번호</th>
						<th>서명</th>
						<th>보낼 도서관</th>
						<th>상호대차상태</th>
						<th>보관일자</th>
						<th>대출하시겠습니까?</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="row" items="${loans.rows}">
						<tr>
							<td>${row.register_num}</td>
							<td>${row.book_name}</td>
							<td>${row.library_name}</td>
							<td>
								<c:choose>
									<c:when test="${row.loan_status eq 0}">도서 준비</c:when>
									<c:when test="${row.loan_status eq 1}">도서 발송</c:when>
									<c:otherwise>도서 도착</c:otherwise>
								</c:choose>
							</td>
							<td><fmt:formatDate type="date" var="store_date" value="${row.store_date}"/>${not empty store_date ? store_date : '------'}</td>
							<td>
								<c:choose>
									<c:when test="${row.status eq 'waiting'}">대기중</c:when>
									<c:when test="${row.status eq 'valid'}">
										<a href="../../tasks/borrow.jsp?register_num=${row.register_num}&loan_num=${row.loan_num}">대출하기</a>
									</c:when>
									<c:otherwise>기한 초과</c:otherwise>
								</c:choose>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</main>
	</body>
</html>