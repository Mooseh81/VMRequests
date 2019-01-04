<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NewRequest.aspx.cs" Inherits="VMRequests.newrequest" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>New VM Request</title>
    <!--#include file="header.html"-->
    <link href="styles/pure-release-1.0.0/pure-min.css" rel="stylesheet" />
    <link href="styles/jquery-ui.min.css" rel="stylesheet" />
    <script type="text/javascript" src="Scripts/jquery-3.3.1.min.js"></script>
    <script type="text/javascript" src="Scripts/jquery-ui.js"></script>
    <script src="Scripts/jquery-1.10.2.min.js"></script>
    <script src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.12.0/jquery.validate.min.js"></script>
    <script type="text/javascript">                
        $(document).ready(function () {
            //custom validation rule for Dropdown List  
            $.validator.addMethod("CheckDropDownList", function (value, element, param) {
                if (value == '0')
                    return false;
                else
                    return true;
            }, "Please select a an item from the list.");
            $("#VMRequestForm").validate({
                rules: {
                     <%=txtVCPU.UniqueID %>:{                           
                        range: [1, 20],
                        required: true,
                },
                    <%=txtMemory.UniqueID %>:{                           
                        range: [1, 64],
                        required: true,
                },
                    <%=txtRFC.UniqueID %>: {                           
                        required: true,
                        digits: true,
                },
                    <%=txtDateRequired.UniqueID %>: {                           
                        required: true,
                },
                    <%=ddlDC.UniqueID %>: {  
                         CheckDropDownList:true  
                },
                    <%=ddlOS.UniqueID %>: {  
                         CheckDropDownList:true  
                },
                    <%=ddlNW.UniqueID %>: {  
                         CheckDropDownList:true  
                },
                    <%=ddlNW.UniqueID %>: {
                    CheckDropDownList: true
                },
                    <%=txtDesc.UniqueID %>: {
                        required: true
                },
                },
            messages: {
                    //This section we need to place our custom validation message for each control.  
                    <%=txtVCPU.UniqueID %>:{  
                        range: "vCPU should be between {0} and {1}"  
                },
                    <%=txtMemory.UniqueID %>: {  
                        range: "Memory should be between {0} and {1}"  
                },
                    <%=txtDateRequired.UniqueID %>: {
                        required: "You need to let us know when you need it"  
            },
                    <%=txtRFC.UniqueID %>: {
                range: "You need to let us know when you need it"
            },    
                },                 
            });  
        });
        $("#btnSubmit").click(function () {
            return $("#VMRequestForm").valid();
        });
    </script>
    <style type="text/css">
        label.error {
            color: red;
            display: inline-flex;
            text-align: right;
        }

	.checkboxlist input {
			margin-bottom: 12px;
			margin-top: 5px;
			margin-right: 20px !important;
	}
	.checkboxlist label {
			color: #ff6a00  !important;
			margin-top: 20px;
			margin-bottom: 12px;
	}
    </style>
    <script>  
        $(function () {
            $('#txtDateRequired').datepicker(
                {
                    dateFormat: 'dd/mm/yy',
                    changeMonth: true,
                    changeYear: true,
                    yearRange: '2018:2100'
                });
        })
    </script>
</head>
<body>
    <div style="position: fixed; top: 50px; left: 10px">
    <div>
    <form id="VMRequestForm" class="pure-form pure-form-aligned" runat="server">
        <div class="pure-control-group">
            <label>Username</label>
            <asp:LoginName ID="txtLogin" runat="server"/>
            (<asp:Label ID="txtemail" runat="server" Text="Label"></asp:Label>
            )</div>
        <div class="pure-control-group">
            <label>Date Required</label>
            <asp:TextBox ID="txtDateRequired" runat="server" />
        </div>
        <div class="pure-control-group">
            <label>Purpose of VM</label>
            <asp:TextBox ID="txtDesc" runat="server" CausesValidation="True" Height="64px" TextMode="MultiLine" ToolTip="Please provide details of what the VM is to be used for.  I.E Web Server for Intapp Time" Width="350px" />
        </div>
        <div class="pure-control-group">
            <label>vCPU</label>
            <asp:TextBox ID="txtVCPU" runat="server" CausesValidation="True"></asp:TextBox>
        </div>
        <div class="pure-control-group">
            <label>Memory(GB)</label>
            <asp:TextBox ID="txtMemory" runat="server" CausesValidation="True"> </asp:TextBox>
        </div>
        <div class="pure-control-group">
            <label>Operating System</label>
            <asp:DropDownList ID="ddlOS" runat="server" DataSourceID="dsOS" DataTextField="name" DataValueField="os_id" AppendDataBoundItems="True">
                <asp:ListItem Value="0">Select</asp:ListItem>
            </asp:DropDownList>
        <div class="pure-controls" style="position:fixed; left:500px; top:30px">
            <label>Software</label>
            <asp:CheckboxList ID="chkSoftware" runat="server" CausesValidation="True" DataSourceID="dsSoftware" DataTextField="software_name" DataValueField="sw_id" CssClass="icheckbox_line-blue" EnableTheming="True" />
        </div>
        </div>
        <div class="pure-control-group">
            <label>Datacentre</label>
            <asp:DropDownList ID="ddlDC" runat="server" DataSourceID="dsDatacentres" DataTextField="datacentre" DataValueField="dc_id" AppendDataBoundItems="True" Width="350px">
                <asp:ListItem Value="0">Select</asp:ListItem>
            </asp:DropDownList>
        </div>
        <div class="pure-control-group">
            <label>Network</label>
            <asp:DropDownList ID="ddlNW" runat="server" DataSourceID="dsNetworks" DataTextField="network" DataValueField="nw_id" AppendDataBoundItems="True" Width="350px">
                <asp:ListItem Value="0">Select</asp:ListItem>
            </asp:DropDownList>
        </div>
        <div class="pure-control-group">
            <asp:CheckBox ID="chkBackup" Text="VM Backup Required" runat="server" ToolTip="Is a backup of the VM required.  SQL Backups are seperate" CssClass="icheckbox_line-blue"/>
        </div>
        <div class="pure-control-group">
            <label>RFC Number</label>
            <asp:TextBox ID="txtRFC" runat="server" CausesValidation="True" />
        </div>
        <div class="pure-controls">
            <asp:Button ID="btnSubmit"
                class="pure-button"
                Text="Submit"
                OnClick="Button1_Click"
                runat="server" />
        </div>
        <asp:SqlDataSource ID="dsOS" runat="server" ConnectionString="<%$ ConnectionStrings:MyConnectionString %>" ProviderName="<%$ ConnectionStrings:MyConnectionString.ProviderName %>" SelectCommand="SELECT [os_id], [name] FROM [OS]" OnSelecting="dsOS_Selecting"></asp:SqlDataSource>
        <asp:SqlDataSource ID="dsDatacentres" runat="server" ConnectionString="<%$ ConnectionStrings:MyConnectionString %>" ProviderName="<%$ ConnectionStrings:MyConnectionString.ProviderName %>" SelectCommand="SELECT [dc_id], [datacentre] FROM [datacentres]"></asp:SqlDataSource>
        <asp:SqlDataSource ID="dsNetworks" runat="server" ConnectionString="<%$ ConnectionStrings:MyConnectionString %>" SelectCommand="SELECT [nw_id], [network] FROM [networks]"></asp:SqlDataSource>
        <asp:SqlDataSource ID="dsSoftware" runat="server" ConnectionString="<%$ ConnectionStrings:MyConnectionString %>" SelectCommand="SELECT * FROM [software]"></asp:SqlDataSource>
    </form>
    </div>
        </div>
</body>
</html>
