<c:set var="theLowerKey" value="${fn:toLowerCase(stringBefore)}" />
         <fmt:message key="ca-${theLowerKey}" var="matchedKey" bundle="${cap}" />
<c:choose>
         <c:when test="${fn:startsWith(matchedKey,'???')}">
            <c:out value="${stringBefore}"/>
         </c:when>
         <c:otherwise>
            <fmt:message key="${matchedKey}" />
            
         </c:otherwise>
</c:choose>
