<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:if test="${evaluationDB == true}">
	<div class="footerWarning">
		<fmt:message key="footer.evaluationDB" />
	</div>
</c:if>
<tiles:insertTemplate template="/WEB-INF/jsp/layout/footer.jsp" />