<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
	<sql:setDataSource var = "snapshot" driver = "oracle.jdbc.driver.OracleDriver"
		url = "jdbc:oracle:thin:@localhost:1521:xe"
		user = "hr"  password = "1234"/>
	<sql:transaction dataSource="${snapshot}">
		<sql:query var="reserves"
			sql="select 
					rlb.reserve_num reserve_num, 
					lb.register_num register_num, 
					b.book_name book_name, 
					lr.library_name library_name, 
					case 
						when rlb.notify_date is null then 
							'waiting' 
						when rlb.notify_date + 1 >= trunc(sysdate) then 
							'valid' 
						else 
							'invalid' 
						end status 
 				from 
					reserve_library_books rlb, 
					library_books lb, 
					books b, 
					libraries lr, 
					reserves r 
				where 
					r.reserve_num = rlb.reserve_num and 
					rlb.register_num = lb.register_num and 
					lb.isbn = b.isbn and 
					lb.library_num = lr.library_num and 
					r.member_num = ?">
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
			<h1>${login_name}님의 예약 기록 <a href="../">back</a></h1>
			<table>
				<thead>
					<tr>
						<th>등록번호</th>
						<th>서명</th>
						<th>대출하시겠습니까?</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="row" items="${reserves.rows}">
						<tr>
							<td>${row.register_num}</td>
							<td>${row.book_name}</td>
							<td>
								<c:choose>
									<c:when test="${row.status eq 'waiting'}">
										대기중 <a href="../../tasks/cancel_reserve.jsp?register_num=${row.register_num}&reserve_num=${row.reserve_num}">X</a>
									</c:when>
									<c:when test="${row.status eq 'valid'}">
										<a href="../../tasks/borrow.jsp?register_num=${row.register_num}&reserve_num=${row.reserve_num}">대출하기</a>
									</c:when>
									<c:otherwise>
										기한 초과 <a href="../../tasks/cancel_reserve.jsp?register_num=${row.register_num}&reserve_num=${row.reserve_num}">X</a>
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</main>
	</body>
</html>