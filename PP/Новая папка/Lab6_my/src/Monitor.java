/*
PP-2
Lab6 . Java. Monitor. Fork/Join
Kobylynskiy Dmytro IP-31
20.04.16
 */
public class Monitor {

    private int n, p;
    private int a, k;
    private int f1, f2;
    private Matrix MR;

    public Monitor(int p, int n) {
        this.p = p;
        this.n = n;
    }

    synchronized void set_a(int a) {
        this.a = a;
    }

    synchronized void set_k(int k) {
        this.k = k;
    }

    synchronized void setMR(int value) {
        MR = new Matrix(n);
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                MR.set(i, j, value);
            }
        }
    }

    synchronized int get_a() {
        return a;
    }

    synchronized int get_k() {
        return k;
    }

    synchronized void getMR(Matrix MR) {
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                MR.set(i, j, this.MR.get(i, j));
            }
        }
    }

    synchronized void waitInput() {
        if (f1 < 3) {
            try {
                wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    synchronized void signalInput() {
        f1++;
        if (f1 == 3) {
            notifyAll();
        }
    }

    synchronized void waitResult() {
        if (f2 < (p - 1)) {
            try {
                wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    synchronized void signalResult() {
        f2++;
        if (f2 == (p - 1)) {
            notifyAll();
        }
    }

}
