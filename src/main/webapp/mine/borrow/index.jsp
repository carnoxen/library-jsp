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
		<sql:query var="borrows"
			sql="select 
					b.borrow_num borrow_num, 
					lb.register_num register_num, 
					bk.book_name book_name, 
					l.library_name library_name, 
					blb.borrow_date borrow_date, 
					blb.extend_count extend_count, 
					f_return_limit(blb.borrow_date, blb.extend_count) return_limit, 
					blb.return_date return_date 
				from 
					borrows b, 
					library_books lb, 
					books bk, 
					libraries l, 
					borrow_library_books blb 
				where 
					b.member_num = ? and 
					b.borrow_num = blb.borrow_num and 
					blb.register_num = lb.register_num and 
					lb.isbn = bk.isbn and 
					lb.library_num = l.library_num and 
					(${not empty param.query ? param.query : '1 = 1'})">
			<sql:param value="${login_id}" />
		</sql:query>
	</sql:transaction>
	<head>
		<meta charset="UTF-8">
		<title>User page</title>
	</head>
	<body>
		<%@ include file="/includes/header.jsp" %>
		<main>
			<h1>${login_name}님의 대출 기록 <a href="../">back</a></h1>
			<form method="get" action="/library/tasks/search_borrow.jsp">
				<p><input type="text" name="search_text" pattern="((book_name|library_name|borrow_date|return_date):(\d{2}\/\d{2}\/\d{2}-\d{2}\/\d{2}\/\d{2}|[\w%]+))+" /><input type="submit" value="search" /></p>
			</form>
			<c:if test="${not empty param.query}">
				<p><span>${param.query}</span> 검색 결과</p>
			</c:if>
			<table>
				<thead>
					<tr>
						<th>등록번호</th>
						<th>서명</th>
						<th>비치 도서관</th>
						<th>대출일자</th>
						<th>남은 연장횟수</th>
						<th>반납기한</th>
						<th>반납일자</th>
						<th>연장하시겠습니까?</th>
						<th>반납하시겠습니까?</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="row" items="${borrows.rows}">
						<sql:query var="someone_reserved" dataSource="${snapshot}"
							sql="select 
									register_num 
								from 
									reserve_library_books 
								where 
									register_num = ? and 
									(notify_date is null or 
									notify_date + 1 >= trunc(sysdate))">
							<sql:param value="${row.register_num}" />
						</sql:query>
						<tr>
							<td><fmt:formatNumber minIntegerDigits="10"  value="${row.register_num}" groupingUsed="false" /></td>
							<td>${row.book_name}</td>
							<td>${row.library_name}</td>
							<td><fmt:formatDate type="date" value="${row.borrow_date}"/></td>
							<td>${row.extend_count}</td>
							<td><fmt:formatDate type="date" value="${row.return_limit}"/></td>
							<td><fmt:formatDate type="date" var="return_date" value="${row.return_date}"/>${not empty return_date ? return_date : '------'}</td>
							<td>
								<c:choose>
									<c:when test="${(row.extend_count gt 0) and (empty row.return_date) and (someone_reserved.rowCount eq 0)}">
										<a href="../../tasks/extend.jsp?register_num=${row.register_num}&borrow_num=${row.borrow_num}">연장하기</a>
									</c:when>
									<c:otherwise>연장불가</c:otherwise>
								</c:choose>
							</td>
							<td>
								<c:choose>
									<c:when test="${empty row.return_date}">
										<a href="../../tasks/return.jsp?register_num=${row.register_num}&borrow_num=${row.borrow_num}">반납하기</a>
									</c:when>
									<c:otherwise>반납됨</c:otherwise>
								</c:choose>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</main>
	</body>
</html>