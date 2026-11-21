<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="PedidosOnlineWeb.Default" ValidateRequest="false" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>OrderFlow | Gestión de Pedidos Online</title>
    <style>
        :root {
            --bg-body: #f1f5f9;
            --bg-card: #ffffff;
            --primary: #0f172a;
            --accent: #2563eb;
            --accent-hover: #1d4ed8;
            --secondary: #64748b;
            --secondary-hover: #475569;
            --danger: #dc2626;
            --danger-bg: #fef2f2;
            --danger-hover: #fee2e2;
            --border: #e2e8f0;
            --text-main: #1e293b;
            --text-muted: #64748b;
            --alert-bg: #eff6ff;
            --alert-border: #bfdbfe;
            --alert-text: #1e40af;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Segoe UI', system-ui, -apple-system, Roboto, sans-serif;
            background-color: var(--bg-body);
            color: var(--text-main);
            line-height: 1.5;
        }

        /* Barra superior */
        .navbar {
            background-color: var(--primary);
            color: #ffffff;
            padding: 16px 32px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 6px rgba(15, 23, 42, 0.15);
            flex-wrap: wrap;
            gap: 10px;
        }

        .navbar-brand {
            font-size: 1.25rem;
            font-weight: 700;
            letter-spacing: -0.02em;
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        .badge-tech {
            background-color: rgba(37, 99, 235, 0.25);
            border: 1px solid rgba(96, 165, 250, 0.4);
            color: #93c5fd;
            font-size: 0.75rem;
            font-weight: 600;
            padding: 3px 10px;
            border-radius: 999px;
        }

        /* Contenedor principal */
        .container {
            max-width: 1280px;
            margin: 28px auto;
            padding: 0 20px;
        }

        /* Alerta de mensajes */
        .alert-box {
            display: block;
            background-color: var(--alert-bg);
            border: 1px solid var(--alert-border);
            color: var(--alert-text);
            padding: 12px 16px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.92rem;
            margin-bottom: 22px;
        }

        .alert-box:empty {
            display: none;
        }

        /* Grid de columnas */
        .grid-layout {
            display: grid;
            grid-template-columns: 1fr 1.15fr;
            gap: 24px;
            align-items: start;
        }

        @media (max-width: 960px) {
            .grid-layout {
                grid-template-columns: 1fr;
            }
        }

        /* Tarjetas */
        .card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
            margin-bottom: 24px;
        }

        .card-header {
            border-bottom: 1px solid var(--border);
            padding-bottom: 12px;
            margin-bottom: 18px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 8px;
        }

        .card-title {
            font-size: 1.08rem;
            font-weight: 700;
            color: var(--primary);
        }

        .code-pill {
            font-family: Consolas, 'Courier New', monospace;
            font-size: 0.78rem;
            background: #f1f5f9;
            color: #334155;
            padding: 3px 8px;
            border-radius: 6px;
            border: 1px solid #cbd5e1;
        }

        .section-subtitle {
            font-size: 0.95rem;
            font-weight: 700;
            color: var(--primary);
            margin: 22px 0 12px 0;
            padding-top: 16px;
            border-top: 1px dashed var(--border);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 8px;
        }

        /* Formularios */
        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 14px;
            margin-bottom: 16px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .form-group label {
            font-size: 0.82rem;
            font-weight: 600;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        .form-control {
            width: 100%;
            padding: 9px 12px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 0.92rem;
            color: var(--text-main);
            background-color: #ffffff;
            transition: border-color 0.15s, box-shadow 0.15s;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15);
        }

        .inline-bar {
            display: flex;
            gap: 10px;
            align-items: flex-end;
            flex-wrap: wrap;
        }

        /* Botones */
        .btn {
            padding: 9px 16px;
            border: none;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.15s, transform 0.05s;
        }

        .btn:active {
            transform: translateY(1px);
        }

        .btn-primary {
            background-color: var(--accent);
            color: #ffffff;
        }

        .btn-primary:hover {
            background-color: var(--accent-hover);
        }

        .btn-secondary {
            background-color: #e2e8f0;
            color: #334155;
        }

        .btn-secondary:hover {
            background-color: #cbd5e1;
        }

        /* Tablas (GridView) */
        .table-wrapper {
            overflow-x: auto;
            margin-top: 12px;
            border: 1px solid var(--border);
            border-radius: 8px;
        }

        .grid-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.88rem;
            text-align: left;
        }

        .grid-table th {
            background-color: #f8fafc;
            color: #475569;
            font-weight: 700;
            text-transform: uppercase;
            font-size: 0.76rem;
            letter-spacing: 0.04em;
            padding: 11px 14px;
            border-bottom: 1px solid var(--border);
        }

        .grid-table td {
            padding: 10px 14px;
            border-bottom: 1px solid var(--border);
            color: var(--text-main);
        }

        .grid-table tr:last-child td {
            border-bottom: none;
        }

        .grid-table tr:hover td {
            background-color: #f8fafc;
        }

        .grid-table a {
            color: var(--accent);
            font-weight: 600;
            text-decoration: none;
            padding: 3px 8px;
            border-radius: 5px;
            background: #eff6ff;
            display: inline-block;
        }

        .grid-table a:hover {
            background: #dbeafe;
        }

        .grid-table a[href*="Delete"] {
            color: var(--danger);
            background: var(--danger-bg);
        }

        .grid-table a[href*="Delete"]:hover {
            background: var(--danger-hover);
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <header class="navbar">
            <div class="navbar-brand">
                <span>OrderFlow DB</span>
                <span style="font-weight:400; color:#94a3b8;">| Gestión de Pedidos Online</span>
            </div>
            <span class="badge-tech">SQL Server · T-SQL · Web Forms</span>
        </header>

        <main class="container">
            <asp:Label ID="lblMensaje" runat="server" CssClass="alert-box" />

            <div class="grid-layout">
                <!-- Columna Izquierda: Operación Transaccional de Pedidos -->
                <div>
                    <div class="card">
                        <div class="card-header">
                            <span class="card-title">Nuevo Pedido</span>
                            <span class="code-pill">sp_RegistrarPedidoUnProducto</span>
                        </div>

                        <div class="form-grid">
                            <div class="form-group">
                                <label for="<%= ddlClientes.ClientID %>">Cliente</label>
                                <asp:DropDownList ID="ddlClientes" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlClientes_SelectedIndexChanged" />
                            </div>
                            <div class="form-group">
                                <label for="<%= ddlProductosPedido.ClientID %>">Producto</label>
                                <asp:DropDownList ID="ddlProductosPedido" runat="server" CssClass="form-control" />
                            </div>
                        </div>

                        <div class="inline-bar">
                            <div class="form-group" style="width: 120px;">
                                <label for="<%= txtCantidad.ClientID %>">Cantidad</label>
                                <asp:TextBox ID="txtCantidad" runat="server" CssClass="form-control" TextMode="Number" Text="1" />
                            </div>
                            <asp:Button ID="btnCrearPedido" runat="server" CssClass="btn btn-primary" Text="Confirmar Pedido" OnClick="btnCrearPedido_Click" />
                        </div>

                        <div class="section-subtitle">
                            <span>Actualizar Estado</span>
                            <span class="code-pill">trg_AuditarCambioEstadoPedido</span>
                        </div>

                        <div class="inline-bar">
                            <div class="form-group" style="width: 110px;">
                                <label for="<%= txtPedidoEstadoID.ClientID %>">Pedido ID</label>
                                <asp:TextBox ID="txtPedidoEstadoID" runat="server" CssClass="form-control" TextMode="Number" placeholder="Ej. 1" />
                            </div>
                            <div class="form-group" style="flex: 1; min-width: 150px;">
                                <label for="<%= ddlEstados.ClientID %>">Nuevo Estado</label>
                                <asp:DropDownList ID="ddlEstados" runat="server" CssClass="form-control" />
                            </div>
                            <asp:Button ID="btnCambiarEstado" runat="server" CssClass="btn btn-secondary" Text="Actualizar" OnClick="btnCambiarEstado_Click" />
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <span class="card-title">Historial del Cliente</span>
                            <span class="code-pill">fn_HistorialPedidosCliente</span>
                        </div>
                        <div class="table-wrapper">
                            <asp:GridView ID="gvHistorial" runat="server" CssClass="grid-table" GridLines="None" AutoGenerateColumns="true" EmptyDataText="Este cliente aún no tiene pedidos registrados." />
                        </div>
                    </div>
                </div>

                <!-- Columna Derecha: Administración de Catálogo (CRUD) -->
                <div>
                    <div class="card">
                        <div class="card-header">
                            <span class="card-title">Catálogo de Productos (CRUD)</span>
                            <span class="code-pill">sp_GuardarProducto · sp_EliminarProducto</span>
                        </div>

                        <asp:HiddenField ID="hfProductoID" runat="server" Value="0" />

                        <div class="form-grid">
                            <div class="form-group">
                                <label for="<%= ddlCategorias.ClientID %>">Categoría</label>
                                <asp:DropDownList ID="ddlCategorias" runat="server" CssClass="form-control" />
                            </div>
                            <div class="form-group">
                                <label for="<%= txtSKU.ClientID %>">SKU</label>
                                <asp:TextBox ID="txtSKU" runat="server" CssClass="form-control" placeholder="Ej. PRD-004" />
                            </div>
                            <div class="form-group" style="grid-column: span 2;">
                                <label for="<%= txtNombreProducto.ClientID %>">Nombre del Producto</label>
                                <asp:TextBox ID="txtNombreProducto" runat="server" CssClass="form-control" placeholder="Ej. Monitor Curvo 27 pulgadas" />
                            </div>
                            <div class="form-group">
                                <label for="<%= txtPrecio.ClientID %>">Precio Unitario ($)</label>
                                <asp:TextBox ID="txtPrecio" runat="server" CssClass="form-control" placeholder="0.00" />
                            </div>
                            <div class="form-group">
                                <label for="<%= txtStock.ClientID %>">Stock Disponible</label>
                                <asp:TextBox ID="txtStock" runat="server" CssClass="form-control" TextMode="Number" placeholder="0" />
                            </div>
                        </div>

                        <div class="inline-bar">
                            <asp:Button ID="btnGuardarProducto" runat="server" CssClass="btn btn-primary" Text="Guardar Producto" OnClick="btnGuardarProducto_Click" />
                            <asp:Button ID="btnLimpiarProducto" runat="server" CssClass="btn btn-secondary" Text="Limpiar Formulario" OnClick="btnLimpiarProducto_Click" />
                        </div>

                        <div class="table-wrapper" style="margin-top: 20px;">
                            <asp:GridView ID="gvProductos" runat="server" CssClass="grid-table" GridLines="None"
                                AutoGenerateColumns="false" DataKeyNames="ProductoID"
                                OnSelectedIndexChanged="gvProductos_SelectedIndexChanged" OnRowDeleting="gvProductos_RowDeleting">
                                <Columns>
                                    <asp:BoundField DataField="ProductoID" HeaderText="ID" />
                                    <asp:BoundField DataField="SKU" HeaderText="SKU" />
                                    <asp:BoundField DataField="NombreProducto" HeaderText="Producto" />
                                    <asp:BoundField DataField="NombreCategoria" HeaderText="Categoría" />
                                    <asp:BoundField DataField="PrecioUnitario" HeaderText="Precio" DataFormatString="{0:C}" />
                                    <asp:BoundField DataField="Stock" HeaderText="Stock" />
                                    <asp:CommandField ShowSelectButton="true" SelectText="Editar" />
                                    <asp:CommandField ShowDeleteButton="true" DeleteText="Eliminar" />
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </form>
</body>
</html>