public class PerfilBiometrico {
    private double estatura;
    private double peso;

    public PerfilBiometrico(double estatura, double peso){
        this.estatura = estatura;
        this.peso = peso;
    }

    public double getEstatura() {
        return estatura;
    }

    public void setEstatura(double estatura) {
        this.estatura = estatura;
    }

    public double getPeso() {
        return peso;
    }

    public void setPeso(double peso) {
        this.peso = peso;
    }

    public String calcularTallaIdeal(){
        double imc = peso / (estatura * estatura);
        String tallaSugerida = "";
        if (imc < 20) {
            tallaSugerida = "S (Pequeña)";
        }   else if (imc >= 20 && imc < 25) {
            tallaSugerida = "M (Media)";
        }   else if (imc >= 25 && imc < 30) {
            tallaSugerida = "L (grande)";
        }   else {
            tallaSugerida = "XL (Extra grande)";
        }
        return tallaSugerida;
    }
}