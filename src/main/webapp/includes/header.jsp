<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%-- 홈페이지 헤더, 로그인 페이지를 제외한 모든 페이지에 적용 --%>
<%-- 로그인 안 했으면 로그인 링크, 했으면 회원 페이지, 로그아웃 링크 제공 --%>
<header>
	<c:choose>
		<c:when test="${not empty login_id}">
			환영합니다 ${login_name}님, 
			<a href="/library/mine">회원 페이지</a>, 
			<a href="/library/tasks/logout.jsp">logout</a>
		</c:when>
		<c:otherwise><a href="/library/login">login</a></c:otherwise>
	</c:choose>
</header>