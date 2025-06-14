import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class bussinessanalysis extends StatelessWidget {
  static const String routname = "bussinessanalysis";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Business Analysis Dashboard',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // KPI Cards Row
            Row(
              children: [
                Expanded(
                    child: _buildKPICard(
                  'Total Customers',
                  '10,500',
                  '17%',
                  true,
                  Colors.blue.shade100,
                  Icons.people,
                )),
                SizedBox(width: 16),
                Expanded(
                    child: _buildKPICard(
                  'Investment Income',
                  '152,326.55 EGP',
                  '20%',
                  true,
                  Colors.blue.shade600,
                  Icons.trending_up,
                )),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    child: _buildKPICard(
                  'Total Order',
                  '1,300',
                  '13%',
                  false,
                  Colors.orange.shade100,
                  Icons.shopping_cart,
                )),
                SizedBox(width: 16),
                Expanded(
                    child: _buildKPICard(
                  'Total Income',
                  '100,585',
                  '35%',
                  true,
                  Colors.cyan.shade100,
                  Icons.account_balance_wallet,
                )),
              ],
            ),
            SizedBox(height: 24),

            // Charts Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _buildMonthlyIncomeChart(),
                ),
                SizedBox(height: 16),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildDesignActivityChart(),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Bottom Charts Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildCustomerOrderChart(),
                ),
              ],
            ),
            SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildEarningsChart()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKPICard(String title, String value, String percentage,
      bool isPositive, Color bgColor, IconData icon) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.white, size: 24),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      isPositive ? Colors.green.shade100 : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : Icons.trending_down,
                      color: isPositive ? Colors.green : Colors.red,
                      size: 12,
                    ),
                    SizedBox(width: 4),
                    Text(
                      percentage,
                      style: TextStyle(
                        color: isPositive ? Colors.green : Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyIncomeChart() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Monthly Income',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'January 2025',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '220,342,123',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 30,
                minY: 0,
                maxY: 350,
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 100),
                      FlSpot(5, 150),
                      FlSpot(10, 120),
                      FlSpot(15, 200),
                      FlSpot(20, 300),
                      FlSpot(25, 250),
                      FlSpot(30, 320),
                    ],
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade400, Colors.blue.shade200],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade100.withOpacity(0.3),
                          Colors.blue.shade50.withOpacity(0.1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesignActivityChart() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Design Activity',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: [
                  PieChartSectionData(
                    color: Colors.blue.shade400,
                    value: 40,
                    title: '1004',
                    titleStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    color: Colors.orange.shade400,
                    value: 30,
                    title: '756',
                    titleStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    color: Colors.yellow.shade400,
                    value: 30,
                    title: '432',
                    titleStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          _buildLegendItem('Mobile', Colors.blue.shade400),
          _buildLegendItem('Website', Colors.orange.shade400),
          _buildLegendItem('Investment', Colors.yellow.shade400),
        ],
      ),
    );
  }

  Widget _buildCustomerOrderChart() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Order',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 150,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                titlesData: FlTitlesData(show: false),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(12, (index) {
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: (index * 8 + 20).toDouble(),
                        color: Colors.blue.shade400,
                        width: 12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              _buildLegendItem('Website', Colors.blue.shade400),
              SizedBox(width: 16),
              _buildLegendItem('Mobile App', Colors.blue.shade200),
              SizedBox(width: 16),
              _buildLegendItem('Customer to Customer', Colors.grey.shade400),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsChart() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Earning from Categories',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20),
          _buildEarningItem('Necklaces', '£75K', '£12K'),
          _buildEarningItem('Design Logo', '£50K', ''),
          _buildEarningItem('Design Illustration', '£25K', ''),
          SizedBox(height: 20),
          Container(
            height: 100,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 30),
                      FlSpot(1, 45),
                      FlSpot(2, 40),
                      FlSpot(3, 55),
                      FlSpot(4, 35),
                      FlSpot(5, 60),
                    ],
                    isCurved: true,
                    color: Colors.blue.shade400,
                    barWidth: 3,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade200.withOpacity(0.3),
                          Colors.blue.shade50.withOpacity(0.1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildEarningItem(String category, String amount, String subAmount) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            category,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (subAmount.isNotEmpty)
                Text(
                  subAmount,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
