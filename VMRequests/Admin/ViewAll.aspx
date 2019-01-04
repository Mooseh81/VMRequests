<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewAll.aspx.cs" Inherits="VMRequests.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <!--#include file="../header.html"-->
    <link href="../styles/pure-release-1.0.0/pure-min.css" rel="stylesheet" />
    <title>View Requests</title>
</head>
<body>
    <form id="form1" runat="server">
        <div class="pure-table pure-table-striped" style="position:fixed; top:50px; left:10px">
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource2" EmptyDataText="There are no data records to display." OnSelectedIndexChanged="GridView1_SelectedIndexChanged">
                <Columns>
                    <asp:BoundField DataField="request_id" HeaderText="Request ID" InsertVisible="False" ReadOnly="True" SortExpression="request_id" />
                    <asp:BoundField DataField="rfc_id" HeaderText="RFC" SortExpression="rfc_id" />
                    <asp:BoundField DataField="name" HeaderText="Name" SortExpression="name" />
                    <asp:BoundField DataField="date_required" HeaderText="Date Required" SortExpression="date_required" />
                    <asp:BoundField DataField="date_requested" HeaderText="Date Requested" SortExpression="date_requested" />
                    <asp:BoundField DataField="vcpu" HeaderText="vCPU" SortExpression="vcpu" />
                    <asp:BoundField DataField="memory" HeaderText="Memory" SortExpression="memory" />
                    <asp:CheckBoxField DataField="backup_required" HeaderText="Backup?" SortExpression="backup_required" />
                    <asp:CheckBoxField DataField="complete" HeaderText="Complete" SortExpression="complete" />
                    <asp:BoundField DataField="datacentre" HeaderText="Datacentre" SortExpression="datacentre" />
                    <asp:BoundField DataField="network" HeaderText="Network" SortExpression="network" />
                    <asp:BoundField DataField="OS" HeaderText="Operating System" SortExpression="OS" />
                    <asp:BoundField DataField="software_name" HeaderText="Software Requested" SortExpression="software_name" />
                    <asp:HyperlinkField HeaderText="Build" ShowHeader="True" DataNavigateUrlFields="request_id" DataNavigateUrlFormatString="../Admin/Build.aspx?requestid={0}" Text="Build" />
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:MyConnectionString %>" SelectCommand="SELECT requests.request_id, requests.name, requests.date_required, requests.vcpu, requests.memory, requests.backup_required, requests.date_requested, requests.complete, requests.rfc_id, datacentres.datacentre, networks.network, OS.name AS OS, requests.vmdesc, requests.email, software.software_name FROM software_requests INNER JOIN software ON software_requests.sw_id = software.sw_id RIGHT OUTER JOIN requests INNER JOIN datacentres ON requests.dc_id = datacentres.dc_id INNER JOIN networks ON requests.nw_id = networks.nw_id INNER JOIN OS ON requests.os_id = OS.os_id ON software_requests.request_id = requests.request_id WHERE (requests.complete IS NULL) ORDER BY requests.date_required"></asp:SqlDataSource>
            <br />
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MyConnectionString %>" SelectCommand="SELECT requests.request_id, requests.name, requests.date_required, requests.vcpu, requests.memory, requests.software, requests.backup_required, requests.date_requested, requests.complete, requests.rfc_id, datacentres.datacentre, networks.network, OS.name AS OS FROM requests INNER JOIN datacentres ON requests.dc_id = datacentres.dc_id INNER JOIN networks ON requests.nw_id = networks.nw_id INNER JOIN OS ON requests.os_id = OS.os_id WHERE (requests.complete IS NULL)"></asp:SqlDataSource>
        </div>
    </form>
</body>
</html>
