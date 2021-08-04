<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%-- 로그인 조건: 자신의 회원번호와 비밀번호 --%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8" />
		<title>Login</title>
	</head>
	<body>
		<main>
			<h1>Please login</h1>
			<form method="post" action="/library/tasks/login.jsp">
				<p><label>id: <input type="number" name="id" maxlength="4" required="required" /></label></p>
				<p><label>password: <input type="password" name="passwd" required="required" /></label></p>
				<p><input type="submit" value="로그인" /></p>
			</form>
			<%-- 로그인 실패하면 에러 메시지 출력 --%>
			<c:if test="${not empty param.error}">
				<p>${param.error}</p>
			</c:if>
		</main>
	</body>
</html>