<%@ include file="/html/portlet/dockbar/init.jsp" %>

<liferay-util:buffer var="dockbar">
    <liferay-util:include page="/html/portlet/dockbar/view.portal.jsp" />
</liferay-util:buffer>
<liferay-util:buffer var="create">
	<liferay-util:include page="/html/portlet/dockbar/create-content.jsp" />
</liferay-util:buffer>

<%
Group group = null;
LayoutSet layoutSet = null;

if (layout != null) {
	group = layout.getGroup();
	layoutSet = layout.getLayoutSet();
}

List<Portlet> portlets = new ArrayList<Portlet>();

for (String portletId : PropsValues.DOCKBAR_ADD_PORTLETS) {
	Portlet portlet = PortletLocalServiceUtil.getPortletById(portletId);

	if ((portlet != null) && portlet.isInclude() && portlet.isActive() && PortletPermissionUtil.contains(permissionChecker, layout, portlet, ActionKeys.ADD_TO_PAGE)) {
		portlets.add(portlet);
	}
}

boolean hasLayoutCustomizePermission = LayoutPermissionUtil.contains(permissionChecker, layout, ActionKeys.CUSTOMIZE);
boolean hasLayoutUpdatePermission = LayoutPermissionUtil.contains(permissionChecker, layout, ActionKeys.UPDATE);

Document docDockbar = Jsoup.parse(dockbar);
%>

<c:if test="<%= !group.isControlPanel() && (!group.hasStagingGroup() || group.isStagingGroup()) && (GroupPermissionUtil.contains(permissionChecker, group.getGroupId(), ActionKeys.ADD_LAYOUT) || hasLayoutUpdatePermission || (layoutTypePortlet.isCustomizable() && layoutTypePortlet.isCustomizedView() && hasLayoutCustomizePermission)) %>">
	<%
	if (docDockbar.getElementsByClass("add-content").size() > 0) {
		docDockbar.getElementsByClass("add-content").get(0).after(create);
	}
	%>
</c:if>

<%= docDockbar.toString() %>