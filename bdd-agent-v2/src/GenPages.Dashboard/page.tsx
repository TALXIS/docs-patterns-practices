import { useEffect, useState, useCallback } from 'react';
import {
  makeStyles,
  Title1,
  Card,
  CardHeader,
  Text,
  Spinner,
  Badge,
  tokens,
  Table,
  TableHeader,
  TableRow,
  TableHeaderCell,
  TableBody,
  TableCell,
  TableCellLayout,
} from '@fluentui/react-components';
import {
  BoxRegular,
  LocationRegular,
  WarningRegular,
} from '@fluentui/react-icons';
import type { GeneratedComponentProps } from './RuntimeTypes';

const LOW_STOCK_THRESHOLD = 10;

interface WarehouseItem {
  dmpp_warehouseitemid: string;
  dmpp_name: string;
  dmpp_sku: string;
  dmpp_quantityonhand: number;
  dmpp_reorderpoint: number;
  '_dmpp_warehouselocationid_value@OData.Community.Display.V1.FormattedValue'?: string;
}

interface DashboardSummary {
  totalItems: number;
  totalLocations: number;
  lowStockCount: number;
}

const useStyles = makeStyles({
  container: {
    display: 'flex',
    flexDirection: 'column',
    gap: tokens.spacingVerticalL,
    padding: tokens.spacingHorizontalXL,
  },
  cardRow: {
    display: 'flex',
    gap: tokens.spacingHorizontalL,
    flexWrap: 'wrap',
  },
  summaryCard: {
    minWidth: '200px',
    flex: '1 1 200px',
  },
  cardBody: {
    display: 'flex',
    alignItems: 'center',
    gap: tokens.spacingHorizontalM,
    padding: tokens.spacingVerticalM,
  },
  cardValue: {
    fontSize: tokens.fontSizeHero800,
    fontWeight: tokens.fontWeightBold,
    lineHeight: tokens.lineHeightHero800,
  },
  lowStock: {
    color: tokens.colorPaletteRedForeground1,
  },
});

const GeneratedComponent = (props: GeneratedComponentProps) => {
  const styles = useStyles();
  const [loading, setLoading] = useState(true);
  const [items, setItems] = useState<WarehouseItem[]>([]);
  const [summary, setSummary] = useState<DashboardSummary>({
    totalItems: 0,
    totalLocations: 0,
    lowStockCount: 0,
  });

  const loadData = useCallback(async () => {
    try {
      const [itemsResult, locationsResult] = await Promise.all([
        props.dataApi.queryTable<WarehouseItem>('dmpp_warehouseitem', {
          select: [
            'dmpp_warehouseitemid',
            'dmpp_name',
            'dmpp_sku',
            'dmpp_quantityonhand',
            'dmpp_reorderpoint',
            '_dmpp_warehouselocationid_value',
          ],
          orderBy: 'dmpp_quantityonhand asc',
          pageSize: 50,
        }),
        props.dataApi.queryTable('dmpp_warehouselocation', {
          select: ['dmpp_warehouselocationid'],
          pageSize: 1,
        }),
      ]);

      const allItems = itemsResult.rows;
      const lowStock = allItems.filter(
        (i) => i.dmpp_quantityonhand <= (i.dmpp_reorderpoint ?? LOW_STOCK_THRESHOLD)
      );

      setItems(allItems);
      setSummary({
        totalItems: allItems.length,
        totalLocations: locationsResult.rows.length,
        lowStockCount: lowStock.length,
      });
    } finally {
      setLoading(false);
    }
  }, [props.dataApi]);

  useEffect(() => {
    loadData();
  }, [loadData]);

  if (loading) {
    return <Spinner label="Loading dashboard..." />;
  }

  return (
    <div className={styles.container}>
      <Title1>Warehouse Dashboard</Title1>

      {/* Summary cards */}
      <div className={styles.cardRow}>
        <Card className={styles.summaryCard}>
          <CardHeader header={<Text weight="semibold">Total Items</Text>} />
          <div className={styles.cardBody}>
            <BoxRegular fontSize={28} />
            <Text className={styles.cardValue}>{summary.totalItems}</Text>
          </div>
        </Card>

        <Card className={styles.summaryCard}>
          <CardHeader header={<Text weight="semibold">Locations</Text>} />
          <div className={styles.cardBody}>
            <LocationRegular fontSize={28} />
            <Text className={styles.cardValue}>{summary.totalLocations}</Text>
          </div>
        </Card>

        <Card className={styles.summaryCard}>
          <CardHeader header={<Text weight="semibold">Low Stock Alerts</Text>} />
          <div className={styles.cardBody}>
            <WarningRegular fontSize={28} />
            <Text className={`${styles.cardValue} ${summary.lowStockCount > 0 ? styles.lowStock : ''}`}>
              {summary.lowStockCount}
            </Text>
          </div>
        </Card>
      </div>

      {/* Inventory table */}
      <Card>
        <CardHeader header={<Text weight="semibold">Inventory Overview</Text>} />
        <Table>
          <TableHeader>
            <TableRow>
              <TableHeaderCell>Item Name</TableHeaderCell>
              <TableHeaderCell>SKU</TableHeaderCell>
              <TableHeaderCell>Qty on Hand</TableHeaderCell>
              <TableHeaderCell>Reorder Point</TableHeaderCell>
              <TableHeaderCell>Status</TableHeaderCell>
            </TableRow>
          </TableHeader>
          <TableBody>
            {items.map((item) => {
              const isLow = item.dmpp_quantityonhand <= (item.dmpp_reorderpoint ?? LOW_STOCK_THRESHOLD);
              return (
                <TableRow key={item.dmpp_warehouseitemid}>
                  <TableCell>
                    <TableCellLayout>{item.dmpp_name}</TableCellLayout>
                  </TableCell>
                  <TableCell>
                    <TableCellLayout>{item.dmpp_sku}</TableCellLayout>
                  </TableCell>
                  <TableCell>
                    <TableCellLayout>{item.dmpp_quantityonhand}</TableCellLayout>
                  </TableCell>
                  <TableCell>
                    <TableCellLayout>{item.dmpp_reorderpoint}</TableCellLayout>
                  </TableCell>
                  <TableCell>
                    <TableCellLayout>
                      <Badge
                        appearance="filled"
                        color={isLow ? 'danger' : 'success'}
                      >
                        {isLow ? 'Low Stock' : 'In Stock'}
                      </Badge>
                    </TableCellLayout>
                  </TableCell>
                </TableRow>
              );
            })}
          </TableBody>
        </Table>
      </Card>
    </div>
  );
};

export default GeneratedComponent;
