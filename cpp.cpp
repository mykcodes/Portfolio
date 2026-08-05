#include <iostream>
using namespace std;
int main () {
    int counter = 0;
    int x=121;
    while ( x>0) {
        counter++;
        x/=10;
    }
    cout<<counter;
    return 0;
}