public class Resena {
    private int calificacion;
    private String comentario;
    private String nombreUsuario;

    public Resena(int calificacion, String comentario, String nombreUsuario){
        this.calificacion = calificacion;
        this.comentario = comentario;
        this.nombreUsuario = nombreUsuario;
    }

    public int getCalificacion() {
        return calificacion;
    }

    public void setCalificacion(int calificacion) {
        this.calificacion = calificacion;
    }

    public String getComentario() {
        return comentario;
    }

    public void setComentario(String comentario) {
        this.comentario = comentario;
    }

    public String getNombreUsuario() {
        return nombreUsuario;
    }

    public void setNombreUsuario(String nombreUsuario) {
        this.nombreUsuario = nombreUsuario;
    }

    public void imprimirResena(){
        String estrellas = "";
        for (int i = 0; i < calificacion; i++){
            estrellas += "⭐"; //Aca tendría que haber estrellas pero no se como colocar o alguna cosa con la que poder cambiar
        }
        System.out.println(estrellas + " | " + nombreUsuario + " dice: " + comentario);
    }
}
