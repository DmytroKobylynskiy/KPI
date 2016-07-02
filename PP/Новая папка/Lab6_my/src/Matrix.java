/*
PP-2
Lab6 . Java. Monitor. Fork/Join
Kobylynskiy Dmytro IP-31
20.04.16
 */
public class Matrix {

    private Vector[] matrix;

    public Matrix(int n) {
        matrix = new Vector[n];
        for (int i = 0; i < n; i++) {
            matrix[i] = new Vector(n);
        }
    }

    public void set(int m, int n, int value) {
        matrix[m].set(n, value);
    }

    public int get(int m, int n) {
        return matrix[m].get(n);
    }

    public void fill(int value) {
        for (int i = 0; i < matrix.length; i++) {
            for (int j = 0; j < matrix.length; j++)
                matrix[i].set(j, value);
        }
    }

    public int size() {
        return matrix.length;
    }

    @Override
    public String toString() {
        String res = "";
        for (int i = 0; i < matrix.length; i++) {
            res += matrix[i].toString() + "\n";
        }
        return res;
    }

}
