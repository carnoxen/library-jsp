<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
	<sql:setDataSource var="snapshot" driver="oracle.jdbc.driver.OracleDriver"
		url="jdbc:oracle:thin:@localhost:1521:xe"
		user="hr"  password="1234"/>
	<sql:transaction dataSource="${snapshot}">
		<%-- 어떤 도서의 모든 정보 취득 --%>
		<sql:query var="book"
			sql="select 
					* 
				from 
					books 
				where 
					isbn = ?">
			<sql:param value="${param.isbn}" />
		</sql:query>
		<%-- 한 도서의 모든 저자 이름 취득 --%>
		<sql:query var="authors"
			sql="select 
					author_name 
				from 
					authors a, 
					book_authors ba 
				where 
					a.author_num = ba.author_num and 
					ba.isbn = ?">
			<sql:param value="${param.isbn}" />
		</sql:query>
		<%-- 도서관 비치도서의 상태 및 기타 정보 취득 --%>
		<sql:query var="library_books"
			sql="select 
					lb.register_num register_num, 
					l.library_name library_name 
				from 
					library_books lb,
					libraries l
				where 
					lb.library_num = l.library_num and
					lb.isbn = ?">
			<sql:param value="${param.isbn}" />
		</sql:query>
		<%-- 자신이 얼마나 대출했는가 --%>
		<sql:query var="i_borrowed"
			sql="select 
					* 
				from 
					borrow_library_books blb, 
					borrows b 
				where 
					blb.borrow_num = b.borrow_num and 
					blb.return_date is null and 
					b.member_num = ?">
			<sql:param value="${login_id}" />
		</sql:query>
		<%-- 자신이 얼마나 상호대차했는가 --%>
		<sql:query var="i_loaned"
			sql="select 
					* 
				from 
					loan_library_books llb, 
					loans l 
				where 
					llb.loan_num = l.loan_num and 
					l.member_num = ?">
			<sql:param value="${login_id}" />
		</sql:query>
		<%-- 자신이 얼마나 예약했는가 --%>
		<sql:query var="i_reserved"
			sql="select 
					* 
				from 
					reserve_library_books rlb, 
					reserves r 
				where 
					rlb.reserve_num = r.reserve_num and 
					r.member_num = ?">
			<sql:param value="${login_id}" />
		</sql:query>
		<%-- 연체 도서가 있는가 --%>
		<sql:query var="i_expired"
			sql="select 
					* 
				from 
					borrow_library_books blb, 
					borrows b 
				where 
					blb.borrow_num = b.borrow_num and 
					blb.return_date is null and 
					f_return_limit(blb.borrow_date, blb.extend_count) < trunc(sysdate) and 
					b.member_num = ?">
			<sql:param value="${login_id}" />
		</sql:query>
		<%-- 대출제한, 상호대차 제한이 있는가, 자신의 소속 도서관까지 취득 --%>
		<sql:query var="member_info"
			sql="select 
					borrow_restrict_limit, 
					loan_restrict_limit 
				from 
					members 
				where 
					member_num = ?">
			<sql:param value="${login_id}" />
		</sql:query>
		<c:forEach var="row" items="${member_info.rows}">
			<c:set var="login_borrow_restrict_limit" value="${row.borrow_restrict_limit}" />
			<c:set var="login_loan_restrict_limit" value="${row.loan_restrict_limit}" />
		</c:forEach>
	</sql:transaction>
	<head>
		<meta charset="UTF-8">
		<title>User page</title>
	</head>
	<body>
		<%@ include file="/includes/header.jsp"%>
		<main>
			<%-- ISBN을 기준으로 한 도서의 정보 출력 --%>
			<c:forEach var="row" items="${book.rows}">
				<h1>책 제목: ${row.book_name}</h1>
				<table>
					<tbody>
						<tr>
							<td>ISBN</td>
							<td>${row.isbn}</td>
						</tr>
						<tr>
							<td>지은이</td>
							<td>
								<c:forEach var="author" items="${authors.rows}" varStatus="stat">
									${author.author_name}${stat.last ? '' : ', '}
								</c:forEach>
							</td>
						</tr>
						<tr>
							<td>출판사</td>
							<td>${row.publisher}</td>
						</tr>
						<tr>
							<td>출판 날짜</td>
							<td><fmt:formatDate type="date" value="${row.publish_date}"/></td>
						</tr>
					</tbody>
				</table>
			</c:forEach>
			<%-- ISBN을 기준으로 책의 정보 출력 --%>
			<h2>소장된 책들</h2>
			<table>
				<thead>
					<tr>
						<th>등록번호</th>
						<th>소장 도서관</th>
						<th>대출/예약</th>
						<th>상호대차</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="row" items="${library_books.rows}">
						<%-- 이 책을 대출/상호대차/예약했는가? --%>
						<sql:transaction dataSource="${snapshot}">
							<sql:query var="someone_borrowed"
								sql="select 
										* 
									from 
										borrow_library_books blb, 
										borrows b 
									where 
										blb.borrow_num = b.borrow_num and 
										blb.return_date is null and 
										blb.register_num = ?">
								<sql:param value="${row.register_num}" />
							</sql:query>
							<sql:query var="someone_loaned"
								sql="select 
										* 
									from 
										loan_library_books llb, 
										loans l 
									where 
										llb.loan_num = l.loan_num and 
										llb.register_num = ?">
								<sql:param value="${row.register_num}" />
							</sql:query>
							<sql:query var="i_borrowed_this_book"
								sql="select 
										* 
									from 
										borrow_library_books blb, 
										borrows b 
									where 
										blb.return_date is null and 
										blb.borrow_num = b.borrow_num and 
										b.member_num = ? and 
										blb.register_num = ?">
								<sql:param value="${login_id}" />
								<sql:param value="${row.register_num}" />
							</sql:query>
							<sql:query var="i_loaned_this_book"
								sql="select 
										* 
									from 
										loan_library_books llb, 
										loans l 
									where 
										llb.loan_num = l.loan_num and 
										l.member_num = ? and 
										llb.register_num = ?">
								<sql:param value="${login_id}" />
								<sql:param value="${row.register_num}" />
							</sql:query>
							<sql:query var="i_reserved_this_book"
								sql="select 
										* 
									from 
										reserve_library_books rlb, 
										reserves r 
									where 
										rlb.reserve_num = r.reserve_num and 
										r.member_num = ? and 
										rlb.register_num = ?">
								<sql:param value="${login_id}" />
								<sql:param value="${row.register_num}" />
							</sql:query>
						</sql:transaction>
						<%-- 대출 우선 조건: 연체 도서가 있는가? 대출 제한 기한이 있는가? 도서 신청(대출, 상호대차, 예약)이 3을 넘었는가? --%>
						<c:set var="total_count" value="${i_borrowed.rowCount + 
															i_loaned.rowCount + 
															i_reserved.rowCount}" />
						<c:set var="priority_condition" value="${(i_expired.rowCount eq 0) and 
																(empty login_borrow_restrict_limit) and 
																(total_count lt 3)}" />
						<c:set var="is_in" value="${(someone_borrowed.rowCount eq 0) and 
													(someone_loaned.rowCount eq 0)}" />
						<tr>
							<td><fmt:formatNumber minIntegerDigits="10" 
									value="${row.register_num}" 
									groupingUsed="false" /></td>
							<td>${row.library_name}</td>
							<td>
								<c:choose>
									<c:when test="${not empty login_id}">
										<c:choose>
											<c:when test="${is_in}">
												<c:choose>
													<c:when test="${priority_condition}">
														<a href="../tasks/borrow.jsp?register_num=${row.register_num}">대출하기</a>
													</c:when>
													<c:otherwise>대출불가</c:otherwise>
												</c:choose>
											</c:when>
											<c:otherwise>
												<c:choose>
													<c:when test="${priority_condition and (i_borrowed_this_book.rowCount eq 0) and (i_reserved_this_book.rowCount eq 0) and (i_loaned_this_book.rowCount eq 0)}">
														<a href="../tasks/reserve.jsp?register_num=${row.register_num}">예약하기</a>
													</c:when>
													<c:otherwise>예약불가</c:otherwise>
												</c:choose>
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:otherwise>-----</c:otherwise>
								</c:choose>
							</td>
							<td>
								<c:choose>
									<c:when test="${not empty login_id}">
										<c:choose>
											<c:when test="${is_in}">
												<c:choose>
													<c:when test="${priority_condition}">
														<a href="../loan?register_num=${row.register_num}">상호대차하기</a>
													</c:when>
													<c:otherwise>상호대차불가</c:otherwise>
												</c:choose>
											</c:when>
											<c:otherwise>상호대차불가</c:otherwise>
										</c:choose>
									</c:when>
									<c:otherwise>-----</c:otherwise>
								</c:choose>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</main>
	</body>
</html>