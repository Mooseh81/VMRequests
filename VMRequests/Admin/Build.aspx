<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Build.aspx.cs" Inherits="PowerShellExecution.Default" Debug="true" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <!--#include file="../header.html"-->
</head>
<body>
    <form id="form1" runat="server" class="pure-form pure-form-aligned">
        <div class="pure-table pure-table-striped" style="position:relative">
            <div style="position: fixed; top: 50px; left: 10px">
            <asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False" DataSourceID="SqlDataSource1" Height="50px" Width="455px">
                <Fields>
                    <asp:BoundField DataField="request_id" HeaderText="request_id" InsertVisible="False" ReadOnly="True" SortExpression="request_id" />
                    <asp:BoundField DataField="name" HeaderText="Requested By" SortExpression="name" />
                    <asp:BoundField DataField="date_required" HeaderText="Date Required" SortExpression="date_required" />
                    <asp:BoundField DataField="vcpu" HeaderText="vCPU" SortExpression="vcpu" />
                    <asp:BoundField DataField="memory" HeaderText="Memory(GB)" SortExpression="memory" />
                    <asp:BoundField DataField="software_name" HeaderText="Software" SortExpression="software_name" />
                    <asp:CheckBoxField DataField="backup_required" HeaderText="Backup?" SortExpression="backup_required" />
                    <asp:BoundField DataField="date_requested" HeaderText="Date Requested" SortExpression="date_requested" />
                    <asp:CheckBoxField DataField="complete" HeaderText="Complete" SortExpression="complete" />
                    <asp:BoundField DataField="rfc_id" HeaderText="RFC" SortExpression="rfc_id" />
                    <asp:BoundField DataField="datacentre" HeaderText="Datacentre" SortExpression="datacentre" />
                    <asp:BoundField DataField="network" HeaderText="Network" SortExpression="network" />
                    <asp:BoundField DataField="OS" HeaderText="Operating System" SortExpression="OS" />
                    <asp:BoundField DataField="email" HeaderText="Email" SortExpression="email" />
                    <asp:BoundField DataField="vmdesc" HeaderText="Description" SortExpression="vmdesc" />
                </Fields>
            </asp:DetailsView>
                </div>
            <div style="position: fixed; top: 50px; left: 400px">
                <div class="pure-control-group">
                    <label for="txtVMName">VMName</label>
                    <asp:TextBox ID="txtVMName" runat="server"></asp:TextBox>
                </div>
                <div class="pure-control-group">
                    <label for="txtIPAddress">IP Address</label>
                    <asp:TextBox ID="txtIPAddress" runat="server"></asp:TextBox>
                </div>
                <div class="pure-control-group">
                    <label for="txtUsername">Username</label>
                    <asp:TextBox ID="txtUsername" runat="server"></asp:TextBox>
                    </div>
                    <div class="pure-control-group">
                    <label for="txtPassword">Password</label>
                    <asp:TextBox ID="txtPassword" TextMode="Password" runat="server"></asp:TextBox>
                </div>

                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MyConnectionString %>" SelectCommand="SELECT requests.request_id, requests.name, requests.date_required, requests.vcpu, requests.memory, requests.software, requests.backup_required, requests.date_requested, requests.complete, requests.rfc_id, datacentres.datacentre, networks.network, OS.name AS OS, requests.email, requests.vmdesc, software.software_name FROM software_requests INNER JOIN software ON software_requests.sw_id = software.sw_id RIGHT OUTER JOIN requests INNER JOIN datacentres ON requests.dc_id = datacentres.dc_id INNER JOIN networks ON requests.nw_id = networks.nw_id INNER JOIN OS ON requests.os_id = OS.os_id ON software_requests.request_id = requests.request_id WHERE (requests.request_id = @request_id)">
                    <SelectParameters>
                        <asp:QueryStringParameter Name="request_id" QueryStringField="requestid" Type="Int32" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <div class="pure-controls">
                    <asp:Button ID="ExecuteCode" runat="server" Text="Execute" Width="200" OnClick="ExecuteCode_Click" />

                    <asp:Button ID="Button1" runat="server" Text="Mark Complete" OnClick="ExecuteCodeComplete_Click" />

                </div>
                <div class="pure-controls">
                    <asp:TextBox ID="ResultBox" TextMode="MultiLine" Width="376px" Height="125px" runat="server" BackColor="LightGray"></asp:TextBox>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
