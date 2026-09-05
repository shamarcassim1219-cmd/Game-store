@override
Widget build(BuildContext context) {
  return Scaffold(
    body: _screens[_currentIndex],
    floatingActionButton: FloatingActionButton.extended(
      backgroundColor: Colors.blueAccent,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddListingScreen()),
        );
      },
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text("Sell Account", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    ),
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: _currentIndex,
      backgroundColor: const Color(0xFF1E1E1E),
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: "Wallet"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
      ],
    ),
  );
}
