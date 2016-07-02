/*
PP-2
Lab6 . Java. Monitor. Fork/Join
Kobylynskiy Dmytro IP-31
20.04.16
 */
public class Main {

    public static void main(String[] args) {
        for (int i = 0; i < 6; i++) {
            new Task().start();
        }
    }

}
