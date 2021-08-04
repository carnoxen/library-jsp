<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 메인 페이지. 책 검색 --%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8" />
		<title>Home page</title>
	</head>
	<body>
		<%@ include file="/includes/header.jsp" %>
		<main>
			<h1>책을 검색해주세요</h1>
			<%-- 도서 검색 조건: 서명, 도서관 이름, 저자 이름, 출판사명, 출판일자(기간) --%>
			<%-- 예시 1) book_name:hello --%>
			<%-- 예시 2) ~book_name:h% &author_name:kevin --%>
			<%-- 예시 3) ~publish_date:11/01/01-12/01/01 --%>
			<%-- *을 입력할 경우 모든 도서를 검색 --%>
			<form method="get" action="/library/tasks/search.jsp">
				<p>
					<input type="text" name="search_text" 
						pattern="(~?(book_name|library_name|author_name|publisher|publish_date):(\d{2}\/\d{2}\/\d{2}-\d{2}\/\d{2}\/\d{2}|[\w%]+)(\s+[&|]~?(book_name|library_name|author_name|publisher|publish_date):(\d{2}\/\d{2}\/\d{2}-\d{2}\/\d{2}\/\d{2}|[\w%]+))*|\*)" /> 
					<input type="submit" value="search" />
				</p>
			</form>
		</main>
	</body>
</html>