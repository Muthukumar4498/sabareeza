<%@ Page Language="VB" AutoEventWireup="false" CodeFile="GenerateReceipt.aspx.vb" Inherits="Common_GenerateReceipt" %>

<%@ Register Src="~/Controls/NewHeader.ascx" TagName="Header_welcome" TagPrefix="uc_header_welcome" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Generate Receipt</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <%--     CSS    --%>
    <link href="../css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="../css/newstyle.css" rel="stylesheet" type="text/css" />
    <link href="../css/font-awesome.min.css" rel="Stylesheet" type="text/css" />
    <link href="../css/jquery-ui.min.css" rel="Stylesheet" type="text/css" />
    <link href="../css/Custom-jquery-ui.css" rel="stylesheet" type="text/css" />
    <link href="../css/Custom-ui.jqgrid.css" rel="stylesheet" type="text/css" />
    <link href="../css/sumoselect.css" rel="stylesheet" type="text/css" />
    <link href="../css/daterangepick.css" rel="stylesheet" type="text/css" />
    <%--   !  CSS    --%>
    <%--     JS    --%>
    <script src="../js/jquery-1.11.3.min.js" type="text/javascript"></script>
    <script src="../js/bootstrap.min.js" type="text/javascript"></script>
    <script src="../js/jquery.slimscroll.js" type="text/javascript"></script>
    <script src="../js/moment.min.js" type="text/javascript"></script>
    <script src="../js/daterangepicker.js" type="text/javascript"></script>
    <script src="../js/jquery-ui.min.js" type="text/javascript"></script>
    <script src="../js/jquery.sumoselect.min.js" type="text/javascript"></script>
    <script src="../js/jquery.mask.js" type="tet/javascript"></script>
    <script src="../js/Custom.multiselect.js" type="text/javascript"></script>
    <script src="../js/Custom-grid.locale-en.js" type="text/javascript"></script>
    <script src="../js/Custom.jqGrid.src.js" type="text/javascript"></script>
    <style type="text/css">
        .AlgRgh {
            text-align: right;
            font-family: Verdana, Arial, Helvetica, sans-serif;
        }

        .SumoSelect {
            height: 26px !important;
            width: 100% !important;
            line-height: 25px;
        }

            .SumoSelect .select-all {
                height: auto;
            }

            .SumoSelect > .optWrapper {
                width: 100% !important;
            }

                .SumoSelect > .optWrapper > .options li label {
                    margin-top: 0px;
                }

        .SelectBox {
            padding: 0px 8px !important;
        }

        .pad-bot-5px {
            padding-bottom: 5px;
        }

        .DownloadLink {
            color: Blue;
            cursor: pointer;
            text-decoration: underline;
        }

        .form-group {
            margin-bottom: 0px;
        }

        .daterangepicker.show-calendar .calendar {
            display: inline-block !important;
        }

        .glyph-cal img {
            height: 15px !important;
        }

        .range_inputs {
            float: right;
        }

        .SumoSelect {
            width: 100% !important;
            line-height: 30px;
        }

            .SumoSelect .select-all {
                height: auto;
            }

            .SumoSelect > .optWrapper {
                width: 100% !important;
            }

                .SumoSelect > .optWrapper > .options li label {
                    margin-top: 0px;
                }

            .SumoSelect > .CaptionCont > label > i {
                margin-top: 40px !important;
            }
    </style>
    <script type="text/javascript">
        function ShowLoader() {
            $('#loadingmessage').show();
        }
        var intervalId, jsonArr = [];
        $(document).ready(function () {
            window.addEventListener("load", function (event) {
                $('#loadingmessage').fadeOut(1000);
            });
            //var strDate = '';
           
            var drp = $('#txtTransDate');
            drp.daterangepicker({
                autoUpdateInput: false,
                linkedCalendars: false,
                locale: {
                    format: 'YYYY/MM/DD'
                }
            },
                function (start, end) {
                    strDate = start.format('YYYY/MM/DD') + ' - ' + end.format('YYYY/MM/DD');
                });
            $('#txtTransDate').on('apply.daterangepicker', function (ev, picker) {
                if (strDate == '') {
                    strDate = moment().format("YYYY/MM/DD") + ' - ' + moment().format("YYYY/MM/DD");
                }
                $('#txtTransDate').val(strDate);
            });
            $('#txtTransDate').on('cancel.daterangepicker', function (ev, picker) {
                $('#txtTransDate').val('');
            });
            $("[id*=chkSelectAll]").click(function () {

                var chkHeader = $(this);
                var grid = $(this).closest("table");
                $("input[type=checkbox]", grid).each(function () {
                    if (chkHeader.is(":checked")) {
                        $(this).prop("checked", "checked");

                    } else {
                        $(this).removeProp("checked");

                    }
                });
            });
            $("[id*=chkSelect]").click(function () {
                var grid = $(this).closest("table");
                var chkHeader = $("[id*=chkSelectAll]", grid);
                if (!$(this).is(":checked")) {

                    chkHeader.removeProp("checked");
                } else {

                    if ($("[id*=chkSelect]", grid).length == $("[id*=chkSelect]:checked", grid).length) {
                        chkHeader.prop("checked", "checked");
                    }
                }
            });

            $("#ddlDept").SumoSelect({ selectAll: true });
        });

        function ValidateSearch() {

            var SelectedtxtDept = "";
            $('#ddlDept option:selected').each(function (i) {
                SelectedtxtDept += $(this).val() + ",";
            });
            SelectedtxtDept = SelectedtxtDept.slice(0, -1)
            if (SelectedtxtDept == "") {
                alert("Please select a department to run a search.");
                return false;
            }
            $("#hdnDept").val(SelectedtxtDept);
            var txtTransDate = $("#txtTransDate").val();
            if (txtTransDate == "") {
                alert("Please enter a trans date criteria to run a search.");
                return false;
            }
            ShowLoader();
            return true;
        }

        function Validatereceipt()
        {
            var valid = false;
            var chkselectcount = 0;
            var gridview = document.getElementById('gvPayments');
            for (var i = 0; i < gridview.getElementsByTagName("input").length; i++) {
                var node = gridview.getElementsByTagName("input")[i];
                if (node != null && node.type == "checkbox" && node.checked) {
                    valid = true;
                    chkselectcount = chkselectcount + 1;
                }
            }
            if (chkselectcount == 0) {
                alert("Please select one receipt");
                return false;
            }
            else { ShowLoader(); return true; }
          
        }

        function MultiplePrinter(PrintRecptID, ContractDocID) {
            ShowSegmentLoader("1361");
            var MultipleDocID;
            if (PrintRecptID != "") {
                MultipleDocID = PrintRecptID;
            }
            //if (ContractDocID != "") {
            //    MultipleDocID = MultipleDocID + "," + ContractDocID;
            //}

            intervalId = setInterval(function () {
                CheckLoanActionStatus(MultipleDocID)
            }, 3000);
            var TritonDeviceControl = '<%=ConfigurationManager.AppSettings("DeviceControlProtocol").ToString() %>'
            window.location.href = TritonDeviceControl + MultipleDocID;
        }
        var Device_TotalRuntime = 0;
        function CheckLoanActionStatus(_DocID) {
            Device_TotalRuntime = Device_TotalRuntime + 2;
            var hdnDeviceControlTimeout = $("#hdnDeviceControlTimeout").val();
            var hdnDeviceControlErrMsg = $("#hdnDeviceControlErrMsg").val();
            if (Device_TotalRuntime > hdnDeviceControlTimeout) {
                clearInterval(intervalId);
                Device_TotalRuntime = 0;
                HideSegmentLoader();
                ShowLoader();
                alert(hdnDeviceControlErrMsg);

                //window.location = "../Contact/ViewContact_New.aspx";
                $("#btn_Search").click();
            }

            var DocIDs = _DocID.split(",");
            $.ajax({
                url: "../Common/CommonService.asmx/GetDeviceActionStatus",
                type: "POST",
                data: {
                    DocID: _DocID
                },
                dataType: "json"
            }).done(function (response) {
                var responseCount = 0;

                $.each(response.Table, function (key, value) {
                    if (value.ActionStatus == 1367) {
                        responseCount++;
                        var rowobj = GetObjects(jsonArr, "DocID", value.DocID)
                        if (rowobj.length == 0) {
                            jsonArr.push({ DocID: value.DocID });
                            //if (value.TypeID == 1361)
                            //    alert("Receipt printed successfully.");
                            //else if (value.TypeID == 1362)
                            //    alert("Contract printed successfully.");
                            HideLoader();
                        }
                    }
                    else if (value.ActionStatus == 1368) {
                        responseCount++;
                        if (value.TypeID == 1361)
                            alert("Receipt printed failed:" + value.ErrorMsg);
                        else if (value.TypeID == 1362)
                            alert("Contract printed failed:" + value.ErrorMsg);

                    }
                });
                if (DocIDs.length == responseCount) {
                    HideSegmentLoader();
                    clearInterval(intervalId);
                    HideLoader();
                    $("#btn_Search").click();
                    //window.location = "../Contact/ViewContact_New.aspx";
                }
            }).fail(function (response) {
                HideSegmentLoader();
                alert(response.d);
                HideLoader2();
            });
        }
        function GetObjects(obj, key, val) {
            var objects = [];
            for (var i in obj) {
                if (!obj.hasOwnProperty(i)) continue;
                if (typeof obj[i] == 'object') {
                    objects = objects.concat(GetObjects(obj[i], key, val));
                } else if (i == key && obj[key] == val) {
                    objects.push(obj);
                }
            }
            return objects;
        }
        function ShowLoader() {
            $('#loadingmessage').show();
        }
        function HideLoader() {
            $('#loadingmessage').hide();
        }

        function HideSegmentLoader() {
            $("#SegmentLoader").hide();
        }

        function OpenSetupDocumentFile(Filepath) {
            var IsDownload = "Y"
            var win = window.open('../DocumentManagement/NewFileDownload.aspx?File=' + Filepath + '&IsDownload=' + IsDownload, 'window', 'HEIGHT=600,WIDTH=820,top=50,left=50,toolbar=yes,scrollbars=yes,resizable=yes');
            /*   window.location.href = prevPage;*/
            return false;
        }
        function ShowSegmentLoader(TypeID) {
            var loadermsg = '';
            switch (TypeID) {
                case "1167":  // LABEL PRINTER
                    loadermsg = "Please wait while the label is printing."
                    break;
                case "1168": // CARD PRINTER
                    loadermsg = "Please wait while the card is printing."
                    break;
                case "1361": // RECEIPT PRINTER
                    loadermsg = "Please wait while the receipt is printing."
                    break;
                case "1362": // CONTRACT PRINTER
                    loadermsg = "Please wait while the contract is printing."
                    break;
                case "1363": // CHECK PRINTER
                    loadermsg = "Please wait while the check is printing."
                    break;
                case "1364": // CHECK SCANNER
                    loadermsg = "Please wait while the check is scanning."
                    break;
                case "1369": // REPORT PRINTER
                    loadermsg = "Please wait while the report is printing."
                    break;
                case "1370": // REPORT CHECK PRINTER
                    loadermsg = "Please wait while the report check is printing."
                    break;
                case "MultiPrinter": // MULTIPLE PRINTER
                    loadermsg = "Please wait while the document is printing."
                    break;
                default:
                    loadermsg = ''
                    break;
            }
            $(".loader_msg").text(loadermsg);
            $("#SegmentLoader").show();
        }
        function HideSegmentLoader() {
            $("#SegmentLoader").hide();
        }
       
    </script>
    <%--    !  JS    --%>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" />
        <%--  !   JS Loader    --%>
        <div id='loadingmessage' style='display: none'>
            <div class="sk-Container" id="Loadie">
                <div class="sk-fading-circle">
                    <div class="sk-circle1 sk-circle">
                    </div>
                    <div class="sk-circle2 sk-circle">
                    </div>
                    <div class="sk-circle3 sk-circle">
                    </div>
                    <div class="sk-circle4 sk-circle">
                    </div>
                    <div class="sk-circle5 sk-circle">
                    </div>
                    <div class="sk-circle6 sk-circle">
                    </div>
                    <div class="sk-circle7 sk-circle">
                    </div>
                    <div class="sk-circle8 sk-circle">
                    </div>
                    <div class="sk-circle9 sk-circle">
                    </div>
                    <div class="sk-circle10 sk-circle">
                    </div>
                    <div class="sk-circle11 sk-circle">
                    </div>
                    <div class="sk-circle12 sk-circle">
                    </div>
                </div>
            </div>
             <div class="ui segment" id="SegmentLoader" style="display: none;">
            <div class="ui active dimmer">
                <div class="ui massive text loader">
                    <div class="loader_msg"></div>
                </div>
            </div>
        </div>
        </div>
        <%--  !   JS Loader    --%>
        <div>
            <uc_header_welcome:Header_welcome ID="Header_welcome" runat="server" />
            <div id="wrapper-view" style="padding-top: 30px;">
                <div id="nav-toggle-button-view">
                    <div class="side-menu-view">
                        <a href="#menu-toggle" class="btn btn-dept" id="menu-toggle">Action</a>
                    </div>
                </div>
                <!-- Sidebar -->
                <div id="sidebar-wrapper-view">
                    <ul class="sidebar-nav-view">
                        <li class="sidebar-heading-view">
                            <label>
                                <strong>Action Menu</strong></label>
                        </li>
                        <div id="cssmenu">
                            <ul>
                                <li>
                                    <asp:LinkButton ID="lnkBulkReceiptPrint" OnClientClick="return Validatereceipt()" runat="server"><img src="../Icon/Common/PayDay_Common_Print_16x16.png" alt="Save" />Print Receipt</asp:LinkButton></li>
                                <li>
                                    <asp:LinkButton ID="lnkCancel" runat="server" PostBackUrl="~/Default.aspx" OnClientClick="return CancelAudit()"><img src="../Icon/Common/Sales_Common_Cancel_16x16.png" alt="Cancel" />Cancel</asp:LinkButton></li>
                            </ul>
                        </div>
                    </ul>
                </div>
                <!-- /#sidebar-wrapper -->
                <div id="page-content-wrapper-view ">
                    <div class="container-fluid contentmain">
                        <div class="row">
                            <div class="col-md-12" style="padding: 0 15px !important;">
                                <div class="panel panel-default panel-main">
                                    <div class="sidebar-heading" style="height: 31px !important;">
                                        <label>
                                            <strong style="padding-left: 20px;">Generate Receipt</strong></label>
                                    </div>
                                    <div class="panel-body">
                                        <div class="row">
                                            <div class="col-md-12" style="padding-right: 1px !important; padding-left: 1px !important;">
                                                <div class="content-search width_100 form-group" style="padding-left: 20px; line-height: 15px;">
                                                    <table width="100%" border="0" cellspacing="2" cellpadding="5">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <label id="lblState" style="padding-left: 10px; font-size: smaller;">
                                                                        State :</label>
                                                                </td>
                                                                <td>
                                                                    <label id="lblSelectDepartment" style="padding-left: 10px; font-size: smaller;">
                                                                        Select Department :</label>
                                                                </td>
                                                                <td>
                                                                    <label id="lblLoanType" style="padding-left: 10px; font-size: smaller;">
                                                                        Loan Type :</label>
                                                                </td>
                                                                <td>
                                                                    <label id="lblTransDate" style="padding-left: 10px; font-size: smaller;">
                                                                        Trans Date :</label>
                                                                </td>
                                                                <td>
                                                                    <label id="lblReprint" style="padding-left: 10px; font-size: smaller;">
                                                                        Reprint :</label>
                                                                </td>

                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:DropDownList ID="ddlState" runat="server" class="form-control" aria-label="Default"
                                                                        aria-describedby="basic-addon1">
                                                                    </asp:DropDownList>
                                                                </td>
                                                                <td style="width: 100px;">
                                                                    <asp:ListBox ID="ddlDept" SelectionMode="Multiple" CssClass="form-control input-sm" runat="server" Style="height: 33px; width: 400px;"></asp:ListBox>
                                                                </td>
                                                                <td>
                                                                    <asp:DropDownList ID="ddlLoanType" CssClass="form-control" runat="server">
                                                                    </asp:DropDownList>
                                                                </td>
                                                                <td>
                                                                    <asp:TextBox class=" form-control input-sm" runat="server" ID="txtTransDate"></asp:TextBox>
                                                                </td>
                                                                <td>
                                                                    <asp:CheckBox runat="server" ID="chkReprint" Style="padding-left: 10px;"></asp:CheckBox>
                                                                </td>
                                                                <td>
                                                                    <asp:Button ID="btn_Search" runat="server" Text="Search" OnClientClick="return ValidateSearch();" CssClass="btn btn-success" />
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="8">
                                                                    <asp:Label ID="lblError" runat="server" Font-Bold="True" Font-Size="Smaller" ForeColor="Red"
                                                                        Text="Data not found!" Visible="false"></asp:Label>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>


                                        </div>
                                        <div class="row" runat="server" id="GridWithPaging" visible="false">
                                            <div class="col-md-12">
                                                <asp:GridView ID="gvPayments" EmptyDataText="No Records Found." runat="server"
                                                    Width="100%" AutoGenerateColumns="False"
                                                    PageSize="15" AlternatingRowStyle-CssClass="even"
                                                    HeaderStyle-CssClass="gridview_header" CssClass="gridview" CellPadding="3" Style="line-height: 28px;"
                                                    GridLines="None" AllowPaging="false">
                                                    <Columns>
                                                        <%--0--%>
                                                        <asp:TemplateField>
                                                            <ItemTemplate>
                                                                <asp:CheckBox ID="chkSelect" runat="server" />
                                                                <itemstyle width="1%" />
                                                            </ItemTemplate>
                                                            <HeaderTemplate>
                                                                <asp:CheckBox ID="chkSelectAll" runat="server" />
                                                            </HeaderTemplate>
                                                            <ItemStyle Width="2%" />
                                                        </asp:TemplateField>
                                                        <asp:BoundField HeaderText="Store#" DataField="StoreNumber" HeaderStyle-HorizontalAlign="center"
                                                            ItemStyle-HorizontalAlign="Center">
                                                            <ItemStyle Width="3%" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="Store Name" DataField="DeptName" HeaderStyle-HorizontalAlign="center"
                                                            ItemStyle-HorizontalAlign="Center">
                                                            <ItemStyle Width="5%" />
                                                        </asp:BoundField>
                                                        <asp:TemplateField HeaderText="Receipt Date" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Center">
                                                            <ItemTemplate>
                                                                <asp:Label runat="server" ID="lblReceiptDate"><%#objGenFunc.Format_dateNew(DataBinder.Eval(Container.DataItem, "TransDate"))%></asp:Label>
                                                            </ItemTemplate>
                                                            <ItemStyle Width="5%" />
                                                        </asp:TemplateField>
                                                        <asp:BoundField HeaderText="Loan#" DataField="Trans#" HeaderStyle-HorizontalAlign="center"
                                                            ItemStyle-HorizontalAlign="Center">
                                                            <ItemStyle Width="5%" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="TransType" DataField="LoanTypeDesc" HeaderStyle-HorizontalAlign="center"
                                                            ItemStyle-HorizontalAlign="Center">
                                                            <ItemStyle Width="8%" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="Status" DataField="LoanStatusDesc" HeaderStyle-HorizontalAlign="center"
                                                            ItemStyle-HorizontalAlign="Center">
                                                            <ItemStyle Width="8%" />
                                                        </asp:BoundField>
                                                       <%-- <asp:BoundField HeaderText="Last4" DataField="Last4" HeaderStyle-HorizontalAlign="center"
                                                            ItemStyle-HorizontalAlign="Center">
                                                            <ItemStyle Width="5%" />
                                                        </asp:BoundField>--%>
                                                        <asp:TemplateField HeaderText="Amount" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Center">
                                                            <ItemTemplate>
                                                                <asp:Label runat="server" ID="lbl_Payment"><%#objGenFunc.Format_Curr(DataBinder.Eval(Container.DataItem, "Payment"))%></asp:Label>
                                                            </ItemTemplate>
                                                            <ItemStyle Width="5%" />
                                                        </asp:TemplateField>
                                                        <asp:BoundField HeaderText="Customer Last" DataField="LastName" HeaderStyle-HorizontalAlign="center"
                                                            ItemStyle-HorizontalAlign="Center">
                                                            <ItemStyle Width="8%" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="Customer First" DataField="FirstName" HeaderStyle-HorizontalAlign="center"
                                                            ItemStyle-HorizontalAlign="Center">
                                                            <ItemStyle Width="8%" />
                                                        </asp:BoundField>
                                                        <%--11--%>
                                                        <asp:TemplateField HeaderText="">
                                                            <ItemTemplate>
                                                                <asp:LinkButton runat="server" OnClientClick="ShowLoader();" CommandName="lnkPrint"
                                                                    data-toggle="tooltip" data-placement="right" ToolTip="Print" ID="lnkPrint"><img src ="../Icon/Common/Accounting_Common_Print_16x16.png" height="16px" width="16px" alt="Print" /></asp:LinkButton>
                                                            </ItemTemplate>
                                                            <ItemStyle Width="4%" />
                                                        </asp:TemplateField>
                                                        <asp:BoundField HeaderText="12" DataField="TransMID">
                                                            <ItemStyle Width="10px" CssClass="dispnone" />
                                                            <HeaderStyle Width="10px" CssClass="dispnone" />
                                                            <ItemStyle Width="10px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="13" DataField="TransID">
                                                            <ItemStyle Width="10px" CssClass="dispnone" />
                                                            <HeaderStyle Width="10px" CssClass="dispnone" />
                                                            <ItemStyle Width="10px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="14" DataField="DeptID">
                                                            <ItemStyle Width="10px" CssClass="dispnone" />
                                                            <HeaderStyle Width="10px" CssClass="dispnone" />
                                                            <ItemStyle Width="10px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="15" DataField="LoanType">
                                                            <ItemStyle Width="10px" CssClass="dispnone" />
                                                            <HeaderStyle Width="10px" CssClass="dispnone" />
                                                            <ItemStyle Width="10px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="16" DataField="LoanStatus">
                                                            <ItemStyle Width="10px" CssClass="dispnone" />
                                                            <HeaderStyle Width="10px" CssClass="dispnone" />
                                                            <ItemStyle Width="10px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="17" DataField="IsPrinted">
                                                            <ItemStyle Width="10px" CssClass="dispnone" />
                                                            <HeaderStyle Width="10px" CssClass="dispnone" />
                                                            <ItemStyle Width="10px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="18" DataField="ReceiptDocID">
                                                            <ItemStyle Width="10px" CssClass="dispnone" />
                                                            <HeaderStyle Width="10px" CssClass="dispnone" />
                                                            <ItemStyle Width="10px" />
                                                        </asp:BoundField>
                                                    </Columns>
                                                </asp:GridView>
                                            </div>
                                            <div runat="server" id="pagination" style="min-height: 30px !important; max-height: 30px !important;">
                                                <table cellpadding="0" cellspacing="10" width="100%">
                                                    <tr>
                                                        <td style="width: 65%; height: 19px; text-align: left; padding-left: 20px;">
                                                            <b>Page&nbsp;&nbsp;<asp:Label runat="server" ID="lbl_Count"></asp:Label>&nbsp;&nbsp;(Total:<asp:Label runat="server" ID="lblTotal"></asp:Label>)</b>
                                                        </td>
                                                        <td style="height: 19px">
                                                            <asp:LinkButton runat="server" ID="lnk_First" Text="<< First Page"></asp:LinkButton>
                                                        </td>
                                                        <td style="height: 19px">
                                                            <asp:LinkButton runat="server" ID="lnk_Pre" Text="< Previous"></asp:LinkButton>
                                                        </td>
                                                        <td style="height: 19px">
                                                            <asp:LinkButton runat="server" ID="lnk_Next" Text="Next >"></asp:LinkButton>
                                                        </td>
                                                        <td style="height: 19px; padding-right: 20px;">
                                                            <asp:LinkButton runat="server" ID="lnk_Last" Text="Last Page >>"></asp:LinkButton>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <asp:HiddenField ID="hdnDept" runat="server" />
        <asp:HiddenField ID="hdnDeviceControlTimeout" runat="server" />
        <asp:HiddenField ID="hdnDeviceControlErrMsg" runat="server" />
        <asp:HiddenField ID="hdnUseDeviceControl" runat="server" />
    </form>
</body>
</html>
