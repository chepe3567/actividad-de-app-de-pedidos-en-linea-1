using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI.WebControls;

namespace PedidosOnlineWeb
{
    public partial class Default : System.Web.UI.Page
    {
        private string ConnStr => ConfigurationManager.ConnectionStrings["PedidosOnlineConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarCombos();
                CargarProductos();
                CargarHistorialCliente();
            }
        }

        private void CargarCombos()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();

                using (SqlDataAdapter da = new SqlDataAdapter("SELECT ClienteID, NombreCompleto FROM Clientes ORDER BY NombreCompleto", conn))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    ddlClientes.DataSource = dt;
                    ddlClientes.DataTextField = "NombreCompleto";
                    ddlClientes.DataValueField = "ClienteID";
                    ddlClientes.DataBind();
                }

                using (SqlDataAdapter da = new SqlDataAdapter("SELECT CategoriaID, NombreCategoria FROM Categorias WHERE Activo = 1 ORDER BY NombreCategoria", conn))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    ddlCategorias.DataSource = dt;
                    ddlCategorias.DataTextField = "NombreCategoria";
                    ddlCategorias.DataValueField = "CategoriaID";
                    ddlCategorias.DataBind();
                }

                using (SqlDataAdapter da = new SqlDataAdapter("SELECT EstadoID, NombreEstado FROM EstadosPedido ORDER BY EstadoID", conn))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    ddlEstados.DataSource = dt;
                    ddlEstados.DataTextField = "NombreEstado";
                    ddlEstados.DataValueField = "EstadoID";
                    ddlEstados.DataBind();
                }
            }
            CargarComboProductos();
        }

        private void CargarComboProductos()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlDataAdapter da = new SqlDataAdapter(
                "SELECT ProductoID, NombreProducto + ' (Stock: ' + CAST(Stock AS VARCHAR(10)) + ')' AS Descripcion FROM Productos ORDER BY NombreProducto", conn))
            {
                DataTable dt = new DataTable();
                da.Fill(dt);
                ddlProductosPedido.DataSource = dt;
                ddlProductosPedido.DataTextField = "Descripcion";
                ddlProductosPedido.DataValueField = "ProductoID";
                ddlProductosPedido.DataBind();
            }
        }

        private void CargarProductos()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlDataAdapter da = new SqlDataAdapter(@"
                SELECT p.ProductoID, p.CategoriaID, p.SKU, p.NombreProducto, c.NombreCategoria, p.PrecioUnitario, p.Stock
                FROM Productos p
                INNER JOIN Categorias c ON p.CategoriaID = c.CategoriaID
                ORDER BY p.ProductoID DESC", conn))
            {
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvProductos.DataSource = dt;
                gvProductos.DataBind();
            }
        }

        private void CargarHistorialCliente()
        {
            if (string.IsNullOrEmpty(ddlClientes.SelectedValue)) return;

            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlCommand cmd = new SqlCommand("SELECT * FROM dbo.fn_HistorialPedidosCliente(@ClienteID) ORDER BY PedidoID DESC", conn))
            {
                cmd.Parameters.Add("@ClienteID", SqlDbType.Int).Value = int.Parse(ddlClientes.SelectedValue);
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvHistorial.DataSource = dt;
                    gvHistorial.DataBind();
                }
            }
        }

        protected void ddlClientes_SelectedIndexChanged(object sender, EventArgs e)
        {
            CargarHistorialCliente();
        }

        protected void btnCrearPedido_Click(object sender, EventArgs e)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlCommand cmd = new SqlCommand("dbo.sp_RegistrarPedidoUnProducto", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@ClienteID", SqlDbType.Int).Value = int.Parse(ddlClientes.SelectedValue);
                    cmd.Parameters.Add("@ProductoID", SqlDbType.Int).Value = int.Parse(ddlProductosPedido.SelectedValue);
                    cmd.Parameters.Add("@Cantidad", SqlDbType.Int).Value = int.Parse(txtCantidad.Text.Trim());

                    SqlParameter outId = new SqlParameter("@NuevoPedidoID", SqlDbType.Int) { Direction = ParameterDirection.Output };
                    cmd.Parameters.Add(outId);

                    conn.Open();
                    cmd.ExecuteNonQuery();

                    lblMensaje.Text = $"Pedido #{outId.Value} registrado correctamente.";
                }

                CargarProductos();
                CargarComboProductos();
                CargarHistorialCliente();
            }
            catch (Exception ex)
            {
                lblMensaje.Text = $"Error al crear pedido: {ex.Message}";
            }
        }

        protected void btnCambiarEstado_Click(object sender, EventArgs e)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlCommand cmd = new SqlCommand("dbo.sp_ActualizarEstadoPedido", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@PedidoID", SqlDbType.Int).Value = int.Parse(txtPedidoEstadoID.Text.Trim());
                    cmd.Parameters.Add("@NuevoEstadoID", SqlDbType.TinyInt).Value = byte.Parse(ddlEstados.SelectedValue);

                    conn.Open();
                    cmd.ExecuteNonQuery();

                    lblMensaje.Text = "Estado actualizado y registrado en AuditoriaPedidos.";
                }

                CargarHistorialCliente();
            }
            catch (Exception ex)
            {
                lblMensaje.Text = $"Error al actualizar estado: {ex.Message}";
            }
        }

        protected void btnGuardarProducto_Click(object sender, EventArgs e)
        {
            try
            {
                string precioTexto = txtPrecio.Text.Trim().Replace(',', '.');
                decimal precio = decimal.Parse(precioTexto, NumberStyles.Any, CultureInfo.InvariantCulture);

                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlCommand cmd = new SqlCommand("dbo.sp_GuardarProducto", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@ProductoID", SqlDbType.Int).Value = int.Parse(hfProductoID.Value);
                    cmd.Parameters.Add("@CategoriaID", SqlDbType.Int).Value = int.Parse(ddlCategorias.SelectedValue);
                    cmd.Parameters.Add("@SKU", SqlDbType.VarChar, 30).Value = Server.HtmlDecode(txtSKU.Text).Trim();
                    cmd.Parameters.Add("@NombreProducto", SqlDbType.NVarChar, 150).Value = Server.HtmlDecode(txtNombreProducto.Text).Trim();
                    cmd.Parameters.Add("@PrecioUnitario", SqlDbType.Decimal).Value = precio;
                    cmd.Parameters.Add("@Stock", SqlDbType.Int).Value = int.Parse(txtStock.Text.Trim());

                    conn.Open();
                    cmd.ExecuteNonQuery();

                    lblMensaje.Text = "Producto guardado correctamente.";
                }

                LimpiarFormularioProducto();
                CargarProductos();
                CargarComboProductos();
            }
            catch (Exception ex)
            {
                lblMensaje.Text = $"Error al guardar producto: {ex.Message}";
            }
        }

        protected void gvProductos_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridViewRow row = gvProductos.SelectedRow;
            hfProductoID.Value = gvProductos.DataKeys[row.RowIndex].Value.ToString();

            txtSKU.Text = Server.HtmlDecode(row.Cells[1].Text).Trim();
            txtNombreProducto.Text = Server.HtmlDecode(row.Cells[2].Text).Trim();

            string nombreCategoria = Server.HtmlDecode(row.Cells[3].Text).Trim();
            ListItem itemCat = ddlCategorias.Items.FindByText(nombreCategoria);
            if (itemCat != null)
            {
                ddlCategorias.ClearSelection();
                itemCat.Selected = true;
            }

            string precioTexto = Server.HtmlDecode(row.Cells[4].Text).Trim();
            if (decimal.TryParse(precioTexto, NumberStyles.Currency, CultureInfo.CurrentCulture, out decimal precioVal) ||
                decimal.TryParse(precioTexto, NumberStyles.Any, CultureInfo.InvariantCulture, out precioVal))
            {
                txtPrecio.Text = precioVal.ToString("0.00", CultureInfo.InvariantCulture);
            }
            else
            {
                txtPrecio.Text = precioTexto;
            }

            txtStock.Text = Server.HtmlDecode(row.Cells[5].Text).Trim();
        }

        protected void gvProductos_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                int productoId = Convert.ToInt32(gvProductos.DataKeys[e.RowIndex].Value);

                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlCommand cmd = new SqlCommand("dbo.sp_EliminarProducto", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@ProductoID", SqlDbType.Int).Value = productoId;

                    conn.Open();
                    cmd.ExecuteNonQuery();

                    lblMensaje.Text = "Producto eliminado correctamente.";
                }

                CargarProductos();
                CargarComboProductos();
            }
            catch (Exception ex)
            {
                lblMensaje.Text = $"Error al eliminar producto: {ex.Message}";
            }
        }

        protected void btnLimpiarProducto_Click(object sender, EventArgs e)
        {
            LimpiarFormularioProducto();
        }

        private void LimpiarFormularioProducto()
        {
            hfProductoID.Value = "0";
            txtSKU.Text = string.Empty;
            txtNombreProducto.Text = string.Empty;
            txtPrecio.Text = string.Empty;
            txtStock.Text = string.Empty;
            if (ddlCategorias.Items.Count > 0)
            {
                ddlCategorias.SelectedIndex = 0;
            }
        }
    }
}