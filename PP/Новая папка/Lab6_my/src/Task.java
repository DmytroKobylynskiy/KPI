import java.util.concurrent.ForkJoinPool;
/*
PP-2
Lab6 . Java. Monitor. Fork/Join
Kobylynskiy Dmytro IP-31
20.04.16
 */
public class Task extends Thread {

    private static int counter = 1;
    private static Vector B;
    private static Vector C;
    private static Matrix MA;
    private static Matrix MT;
    private static Matrix MO;

    private int id = counter++;
    private int p = 6, n = 6, h = n / p;

    private static Monitor monitor;

    public Task() {
        monitor = new Monitor(p, n);
    }

    @Override
    public void run() {

        int copy_a;
        int copy_k;
        Matrix copyMR = new Matrix(n);

        System.out.println("Task " + id + " started!");
        switch (id) {
            case 1 :

                monitor.setMR(1);
                monitor.signalInput();
                break;
            case 4 :
                MA = new Matrix(n);
                MA.fill(0);
                monitor.set_a(1);
                C = new Vector(n);
                C.fill(1);
                monitor.signalInput();
                break;
            case 3 :
                B = new Vector(n);
                MO = new Matrix(n);
                MT = new Matrix(n);
                MT.fill(1);
                B.fill(1);
                MO.fill(1);
                monitor.signalInput();
                break;
        }
        monitor.waitInput();
        ForkJoinPool forkJoinPool = new ForkJoinPool(p);
        CalculateUnits calculateUnits = new CalculateUnits(B,C);
        if (id == 1) {
            monitor.set_k(calculateUnits.splitParts());
        }


        while(monitor.get_k() == 0);
        copy_a = monitor.get_a();
        copy_k = monitor.get_k();
        monitor.getMR(copyMR);

        for (int i = h * (id - 1); i < (h * id); i++) {
            for (int j = 0; j < n; j++) {
                for (int k = 0; k < n; k++) {
                    MA.set(i, j, MA.get(i, j) + MO.get(i, k) * copyMR.get(k, j));
                }
                MA.set(i, j, MA.get(i, j) * copy_k + copy_a * MO.get(i, j));
            }
        }

        if (id == 1) {
            monitor.waitResult();
            System.out.println(MA);
        } else {
            monitor.signalResult();
        }



    }
}
