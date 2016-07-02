/*
PP-2
Lab6 . Java. Monitor. Fork/Join
Kobylynskiy Dmytro IP-31
20.04.16
 */
public class Vector {

    public int[] array;

    public Vector(int n) {
        array = new int[n];
    }

    public void set(int index, int value) {
        array[index] = value;
    }

    public int get(int index) {
        return array[index];
    }

    public void fill(int value) {
        for (int i = 0; i < array.length; i++) {
            array[i] = value;
        }
    }

    public int size() {
        return array.length;
    }

    @Override
    public String toString() {
        String res = "";
        for (int i = 0; i < array.length; i++) {
            res += array[i] + " ";
        }
        return res;
    }
}
